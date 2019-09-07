![RxSwiftWidgets](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/RxSwiftWidgetsBanner.jpg)

RxSwiftWidgets lets you define your UIKit-based user interfaces using a simple, declarative format similar to that used by SwiftUI and Flutter. RxSwiftWidgets is also based on RxSwift, with means that you have all of the reactive data binding and user interface control and functionality you'd expect from such a marriage.

With RxSwiftWidgets, interfaces are composed and described using "widgets" and "modifiers" in a builder pattern. 

```
    LabelWidget($title)
        .color(.red)
        .font(.title1)
```

When rendered, each "widget" of a given type builds a corresponding UIView which is then modified as needed with the desired properties and behaviors.

Combine just a few widgets together, and you can quickly and easily achieve some dynamic user interfaces:

> ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-Menu.png)  ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-Login.png)  ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-Account-Details.png) 

Declarative programming using RxSwiftWidgets eliminates the need for Interface Builder Storyboards, Segues, and NIBs, and even custom UIViewControllers. All of those things are still there, of course, lying in wait for the times when they're truly needed for some bit of custom functionality.

Like SwiftUI, the goal behind RxSwiftWidgets is to eliminate much of the hassle behind creating and developing user interfaces. 

But unlike SwiftUI, with RxSwiftWidgets you also have the power to reach under the hood at any point in time and  directly work with the generated views and interface elements and tweak them to your hearts content.

## Why RxSwiftWidgets?

### SwiftUI

With SwiftUI and Combine on the horizon, why use RxSwiftWidgets and RxSwift? Well, the answer to that question actually lies within the question itself: With SwiftUI and Combine **on the horizon**...

SwiftUI is coming, but not yet released. Same for Combine. 

Perhaps more to the point, **SwiftUI and Combine both require iOS 13 at a minimum.** No support for iOS 12 or iOS 11.

There aren't too many developers who can drop support for earlier versions of iOS in their applications and go iOS 13 only. Which in turn means that most of us wouldn't see any of the benefits of doing declarative, reactive programming for another couple of **years**. 

That's simply too long.

### CwlViews

There are a few other declarative frameworks out there, the most notable of which is Matt Gallagher's [CwlViews](https://www.cocoawithlove.com/blog/introducing-cwlviews.html).

While CwlViews has some cool and interesting features, it's biggest drawback lies in its implementation of its own reactive framework. I firmly believe in RxSwift and perhaps more to the point, RxSwift has a large and loyal base of users plus tons of available resources, books, and articles devoted to it.

I wanted declarative development *and* I wanted my RxSwift. What can I say? I'm greedy.

### Flutter, React Native, et. al.

There are other "cross-platform" frameworks out there, but I'm an iOS Swift developer at heart and doing iOS development in Dart or JavaScript simply doesn't interest me.

# RxSwiftWidgets

In RxSwiftWidgets, screens are composed of widgets that are composed of widgets that are composed of widgets...

Let's look at a simple table view implemented in RxSwiftWidgets, which then links to a detail view. You know, your basic master list / detail view scenario.

> ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-User-List-2.png) ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-User-Details.png) 

## Sample Code

Let's take a quick walk through the code needed to produce the data-driven user list shown above.

```
struct UserListWidget: WidgetView {

    var viewModel = UserListViewModel()

    func widget(_ context: WidgetContext) -> Widget {

        TableWidget([
            DynamicTableSectionWidget(viewModel.$users) {
                TableCellWidget(
                    HStackWidget([
                        UserPhotoWidget(initials: $0.initials, size: 35),
                        LabelWidget($0.name)
                    ])
                    )
                    .accessoryType(.disclosureIndicator)
                }
                .onSelect { (context, path, user) in
                    context.navigator?.push(widget: UserDetailsWidget(user: user))
                    context.tableView?.deselectRow(at: path, animated: true)
                }
            ])
            .onRefresh(initialRefresh: true, handler: { _ in
                self.viewModel.reload()
            })
            .navigationBar(title: "User List", hidden: false)
            .safeArea(false)
        
    }

}
```

Our *UserListWidget* is a *WidgetView*, whose job is to return a single widget container that defines the interface for that view. 

WidgetView's can represent entire screens, as shown here; or they can be used to render portions of a screen, as done here with the *UserPhotoWidget*. Pretty much every screen and custom view we create in an app will be some form of a WidgetView.

### WidgetContext

You'll note that the widget function is called with a WidgetContext. Contexts are provided to widgets when they're being built and contain information about the current state of the view hierarchy as well as references to the current view controller, the current view, and the parent view. 

They also provide access to system services (like the navigator), themes, style information, and other attributes. You can also add your own information or objects to the current context and that information will be visible to any of that widget's children. 

Finally, every context contains a RxSwift DisposeBag that manages any subscriptions or bindings made by that widget or it's children. 

### TableWidget

Moving on, you'll note that our WidgetView's *widget* function returns a *TableWidget* which, as you might expect from the name, will eventually will generate a UITableView. 

```
    TableWidget([ ... ])
```

TableWidgets, in turn, can contain multiple static and dynamic section widgets. Here we have just one in the array passed into the widget initializer, a *DynamicTableSectionWidget*.

### DynamicTableSectionWidget

Our dynamic section widget is bound to an observable array of users in our view model. 

```
    DynamicTableSectionWidget(viewModel.$users) { ... }
```

Whenever the observable sends an event containing a new user array the table rows are dynamically regenerated, one row for each user in our list. The trailing closure is called on demand to map each user into the widget (or widgets) used to display the information for that user.

### TableCellWidget

In this case the widget returned is just a simple *TableCellWidget* that shows the user's photo and name. 

```
    TableCellWidget(
        HStackWidget([
            UserPhotoWidget(initials: $0.initials, size: 35),
            LabelWidget($0.name)
            ])
        )
        .accessoryType(.disclosureIndicator)
```

Note that while you can use a standard text-based table cell in RxSwiftWidgets, the contents of these cells are also defined and built using widgets! 

### DynamicTableSectionWidget Modifiers

```
    .onSelect { (context, path, user) in
        context.navigator?.push(widget: UserDetailsWidget(user: user))
        context.tableView?.deselectRow(at: path, animated: true)
    }
```

Our dynamic section also has an *onSelect* modifier that's called whenever the user taps on a cell. 

As shown, it uses a *navigatior* instance to construct and push a new *UserDetailsWidget* onto the navigation stack.

### TableWidget Modifiers

The *TableWidget* itself has an *onRefresh* modifier. 

```
    .onRefresh(initialRefresh: true, handler: { _ in
        self.viewModel.reload()
     })
```

Here we reload our data when the view is initially created as well as whenever the user does a pull-to-refresh. Like many things in RxSwiftWidgets, simply using the modifier embeds and enables the pull-to-refresh functionality automatically.

The table widget also has a couple of modifiers that control the navigation bar title and appearance, in addition to informing the constraint system that we want our tableview to fill the entire screen and ignore the safearea.

```
    .navigationBar(title: "User List", hidden: false)
    .safeArea(false)
```

### Done

That's it. Go back up and look at the full code sample again and you'll see *all* of the code to define the entire screen ([minus the data loading code in the view model](https://github.com/hmlongco/RxSwiftWidgets/blob/master/RxSwiftWidgetsDemo/Application/Users/UserListWidget.swift)). You didn't manually create and configure a UITableViewController. No delegates. No datasources.

A complete table view with navigation, custom table view cells, dynamic data, and pull-to-refresh, in just under 30 lines of code. Interested?

## Want More Details?

Just for good measure, here's the code for the *UserDetailsWidget*. (Just 42 lines of code)

```
struct UserDetailsWidget: WidgetView {

    var user: User

    func widget(_ context: WidgetContext) -> Widget {
        ScrollWidget(
            VStackWidget([

                ContainerWidget(
                    HStackWidget([
                        UserPhotoWidget(initials: user.initials, size: 80),
                        LabelWidget(user.name)
                            .font(.title1)
                            .color(.red)
                        ]) // HStackWidget
                        .position(.centerHorizontally)
                    ), // ContainerWidget

                DetailsSectionWidget(widgets: [
                    DetailsNameValueWidget(name: "Address", value: user.address),
                    DetailsNameValueWidget(name: "City", value: user.city),
                    DetailsNameValueWidget(name: "State", value: user.state),
                    DetailsNameValueWidget(name: "Zip", value: user.zip),
                    ]),

                DetailsSectionWidget(widgets: [
                    DetailsNameValueWidget(name: "Email", value: user.email),
                    ]),

                ]) // VStackWidget
                .spacing(20)

            ) // ScrollWidget
            .backgroundColor(.systemBackground)
            .safeArea(false)
            .padding(20)
            .navigationBar(title: "User Information", hidden: false)
    }

}
```

After our first walkthrough this code should be equally easy to follow. A *ScrollWidget* builds a UIScrollView. A HStackWidget builds a horizontal UIStackView, and so on.

There may be a few, however, that look somewhat less than obvious...

## Composition

Like SwiftUI and Flutter, RxSwiftWidgets encourages composition. You might have noticed that our details example uses a *DetailsSectionWidget* and a *DetailsNameValueWidget*, and that both the list and the detail screen use a *UserPhotoWidget*.

So what are they? 

Simply more WidgetView's.

Here's the *UserPhotoWidget*.

```
struct UserPhotoWidget: WidgetView {

    var initials: String?
    var size: CGFloat

    func widget(_ context: WidgetContext) -> Widget {
        ZStackWidget([
            LabelWidget(initials)
                .font(size > 40 ? .title1 : .body)
                .alignment(.center)
                .backgroundColor(.gray)
                .color(.white),
            ImageWidget(named: "User-\(initials ?? "")")
            ])
            .height(size)
            .width(size)
            .cornerRadius(size/2)
    }

}
```

Again, things should be looking pretty familiar. Our photo widget consists of an image widget placed directly over a label widget in a z-stack, used to let you visually stack elements on top of one another. 

The z-stack is constrained to the desired size using *height* and *width* modifiers, and is turned into a circle with the *cornerRadius* modifier.

Note that the label widget is adjusting the size of the font used based on the size itself. That lets us use the same user-defined widget on both the list and detail screens.

That's interface *composition*.

The downside to interface composition? Practically speaking... none.

RxSwiftWidgets are highly performant and non-resource intensive. As with SwiftUI, widget/view "definitions" are typically struct-based value types, and many of the modifiers are little more than key path-based assignments.

Generating the actual corresponding UIViews *is* more resource intensive, true, but those views need to be created anyway, regardless of whether or not you use RxSwiftWidgets, build them manually, or generate them from Storyboards. 

The upside? Well, unlike using Storyboards and NIBs and binding them to UIViewControllers and UIViews with dozens of IBOUtlets, this approach actively *encourages* breaking your interface down in small, individual, easily understood and easily testable interface elements.

## RxSwift PropertyWrappers and Observables

Like SwiftUI, RxSwiftWidgets define State and Binding property wrappers. 

```
    @State var username: String = "Michael Long"
    @State var password: String = ""
    @State var authenticated: Bool = false
    @State var error: String = ""
```

These property wrappers wrap RxSwift observables such that when bound to a specific widget attribute any change to the state will update the widget's generated UIView.

In some cases the binding is bidirectional, such as when the above password string is bould to a TextFieldWidget...

```
    TextFieldWidget($password)
````

You can also "listen" to state changes using the *onEvent* modifier.

```
    .onEvent($authenticated.filter { $0 }) { (_, context) in
        context.navigator?.dismiss()
    }
```

The above examples were taken directly from the RxSwiftWidgets' [Login Form demo](https://github.com/hmlongco/RxSwiftWidgets/blob/master/RxSwiftWidgetsDemo/Application/Login/LoginFormWidget.swift).

## Integration

As RxSwiftWidgets are UIKit-based, it's easy to integrate RxSwiftWidgets in an existing app.

Just wrap an RxSwiftWidget in a *UIWidgetHostController* and push it onto the navigation stack. RxSwiftWidgets will take over from there.

```
    let vc = UIWidgetHostController(MyWidget())
    navigationController?.pushViewController(vc, animated: true)
```

It's also possible use widgets in existing layouts, and you can also flip things around and use your own custom UIViews and controls within RxSwiftWidget layouts.

Just instantiate the view, wrap it in a *UIViewWidget*, and insert it into the layout where desired.

```
    VStackWidget([
        ...
        UIViewWidget(MyCustomUIView())
           .hidden(viewModel.customViewIsHidden),
        ...
    ])
```
As shown, you can also manipulate properties on custom views using standard RxSwiftWidget modifiers. Your view is a UIView, after all.

With RxSwiftWidgets, it's also possible to directly manipulate a view's attributes using the *with* modifier. Here we're setting the UITextField's keyboardAppearance as that attribute wasn't yet directly available as a RxSwiftWidget modifier.

```
    TextFieldWidget($username)
        .placeholder("Username / Email Address")
        .with { textField, _ in
            textField.keyboardAppearance = .dark
        }
```

It's also easy to create your own fully integrated widget types. Your choice.

## WIP

RxSwiftWidgets is a *beta* release. 

The current version is fairly stable, with most of the internal core functionality in place. 

This means that up to this point the focus was there and not on simply adding as many switches and sliders and other relatively easy to implement controls and views as possible.

Don't worry, they're coming soon.

Though if you're interesting in implementing a widget or two, just let me know.

## Requirements

RxSwiftWidgets requires Xcode 11 as it uses several features from Swift 5.1.

It also depends on the current release of RxSwift and RxCocoa.

That said, and as mentioned above, RxSwiftWidgets currently runs on iOS 11, 12, and 13. (It may well be possible to take it lower, but I used a couple of iOS 11 and up UIKit dependencies here and there.)

## Author

RxSwiftWidgets was designed, implemented, and documented by [Michael Long](https://www.linkedin.com/in/hmlong/), a Senior Lead iOS engineer at [CRi Solutions](https://www.clientresourcesinc.com/solutions/). CRi is a leader in developing cutting edge iOS, Android, and mobile web applications and solutions for our corporate and financial clients.

* Email: [mlong@clientresourcesinc.com](mailto:mlong@clientresourcesinc.com)
* Twitter: @hmlco

## License

RxSwiftWidgets is available under the MIT license. See the LICENSE file for more info.
