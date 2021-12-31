##
## Entry point fo rthe web platform plugin

import classes
import reactivepkg/plugins
import reactivepkg/components
import reactivepkg/config
import reactivepkg/componentTree

# JS specific imports
when defined(ReactivePlatformWeb):
    import std/dom except Window, class


    ## Prepare the app to be started
    proc prepareReactiveAppPlatform*() =
        discard


    ## Start the app
    proc startReactiveAppPlatform*() =

        # Platform starting!
        echo "[Web Platform] Starting!"

        # Get main component
        let componentID = ReactiveConfig.shared.get("web", "mainWindow")
        
        # Render the specified component tree
        let componentTree = ComponentTree.withRegisteredComponent(componentID)

        # Normally this would be a non-returning function, but in JS we use the browser's event loop,
        # so we don't need to runForever() here.
        # runForever()


    ## Base class for web layouts
    class WebLayout of BaseLayout:

        ## Perform the layout
        method update(component: BaseComponent) = echo "Shouldn't see this"
        

    ## Base class for web components
    class Component of BaseComponent:

        # DOM container for this item
        var element: Element = nil

        # Mark this as a web component
        var platformSpecificType = "web"

        # Get most recent ancestor with a valid element
        method parentElement(): Element =
            if this.parent != nil and Component(this.parent).element != nil: return Component(this.parent).element
            elif this.parent != nil: return Component(this.parent).parentElement()
            else: raiseAssert("No parent element found.")


        # On create
        method onPlatformCreate() =

            # Create element
            this.element = document.createElement("div")

        
        # On mount
        method onPlatformMount() =
        
            # Mount to parent element
            this.parentElement.appendChild(this.element)


        ## Called when the layout changes
        method onPlatformLayout() =

            # Call layout if it exists
            if this.layout != nil and this.layout of WebLayout:
                WebLayout(this.layout).update(this)


        # On unmount
        method onPlatformUnmount() = echo "unmounting"

        ## Overridden by the app, this controls child components to render. By default just renders all children.
        method render(): BaseComponent =

            let g = Group.init()
            g.children = this.children
            return g

        ## Update UI
        method updateUi() = ComponentTreeNode(this.componentTreeNode).synchronize()


    ## Window component
    component Window:

        ## Called when the component is created
        method onPlatformCreate() =

            # Create the DOM element immediately
            this.element = document.createElement("div")
            this.element.className = "reactive-web-window"
            this.element.setAttribute("style", "position: absolute; top: 0px; left: 0px; width: 100%; height: 100%; overflow: hidden; ")


        ## Called when the component is mounted
        method onPlatformMount() =

            # Attach window to the screen
            document.body.appendChild(this.element)


        ## Called when the component is removed
        method onPlatformUnmount() =

            # Remove window element
            echo "[Web] Window unmounted"
            document.body.removeChild(this.element)


        ## Called when the component is destroyed
        method onPlatformDestroy() =

            # Remove dom element from memory
            echo "[Web] Window deleted"
            this.element = nil


    ## Plain view
    component View


    ## Label, displays some text
    component Label:

        # Text
        var text = ""

        # Style properties
        var textColor = ""

        # On create
        method onPlatformCreate() =

            # Create element
            this.element = document.createElement("div")
            this.element.setAttribute("style", "display: inline-block; ")

        # Called when the component is updated
        method onPlatformUpdate() =

            # Update text
            this.element.innerText = this.text


        ## Called when new properties are incoming
        method updateProperties(newProps: BaseComponent) = 
            super.updateProperties(newProps)

            # Copy generic props
            this.text = newProps.Label().text
            this.textColor = newProps.Label().textColor

    
    ## Button component
    component Button:

        # Button title
        var title = "Button"

        # Event: On click
        var onClick: proc() = nil

        # On create
        method onPlatformCreate() =

            # Create element
            this.element = document.createElement("button")


        # Called when the component is updated
        method onPlatformUpdate() =

            # Update text
            this.element.innerText = this.title

            # Register events
            if this.onClick != nil: this.element.onClick = proc(_: Event) = this.onClick()


        ## Called when new properties are incoming
        method updateProperties(newProps: BaseComponent) = 
            super.updateProperties(newProps)

            # Copy generic props
            this.title = newProps.Button().title
            this.onClick = newProps.Button().onClick

    
    ##
    ## Absolute layout. This layout system simply moves the object to an absolute position within it's parent.
    class AbsoluteLayout of WebLayout:

        ## Coordinates. Examples are: "32px", "50%".
        var x = ""
        var y = ""
        var width = ""
        var height = ""

        ## Perform the layout
        method update(component: BaseComponent) =
            
            # Get element
            let element = Component(component).element
            if element == nil:
                return

            # Set layout
            element.style.setProperty("position", "absolute")
            element.style.setProperty("left", this.x)
            element.style.setProperty("top", this.y)
            element.style.setProperty("width", this.width)
            element.style.setProperty("height", this.height)


    # System alert dialog icons
    type AlertIconType* = enum information, warning, question

    # System alert dialog ... on web, only the text field is supported
    proc alert*(text: string, title: string = "", icon: AlertIconType = information) =
        window.alert(text)