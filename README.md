# RxSwiftWidgets 

A Declarative Interface Builder for UIKit using Swift 5.1 and RxSwift.

## Introduction

RxSwiftWidgets lets you define your UIKit-based user interfaces using a simple, declarative format similar to that used by SwiftUI and Flutter. RxSwiftWidgets is also based on RxSwift, with means that you have all of the reactive data binding and user interface control and functionality you'd expect from such a marriage.

With RxSwiftWidgets, interfaces are composed and described using "widgets" and "modifiers" in a builder pattern. 

```
    LabelWidget($title)
        .color(.red)
        .font(.title1)
```

When rendered, each "widget" builds a corresponding UIView which is then modified as needed with the desired properties and behaviors.

Combine just a few widgets together, and you can achieve some dynamic user interfaces:

> ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-Menu.png)  ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-Login.png)  ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-Account-Details.png) 

Declarative programming using RxSwiftWidgets eliminates the need for Interface Builder Storyboards, Segues, and NIBs, and even custom UIViewControllers. All of those things are still there, of course, lying in wait for the times when they're truly needed for some bit of custom functionality.

Like SwiftUI, the goal behind RxSwiftWidgets is to eliminate much of the hassle behind creating and developing user interfaces. 

But unlike SwiftUI, with RxSwiftWidgets you also have the power to reach under the hood at any point in time and  directly work with the generated views and interface elements and tweak them to your hearts content.

RxSwiftWidgets are also highly performant and non-resource intensive. As with SwiftUI, widget/view "definitions" are typically struct-based value types, and many of the modifiers are little more than key path-based assignments.

## Why RxSwiftWidgets?

With SwiftUI and Combine on the horizon, why use RxSwiftWidgets and RxSwift? Well, the answer to that question actually lies within the question itself: With SwiftUI and Combine **on the horizon**...

SwiftUI is coming, but not yet released. Same for Combine. 

Perhaps more to the point, **SwiftUI and Combine both require iOS 13 at a minimum.** No support for iOS 12 or iOS 11.

There aren't too many developers who can drop support for earlier versions of iOS in their applications and go iOS 13 only. Which in turn means that most of us wouldn't see any of the benefits of doing declarative, reactive programming for another couple of **years**. 

That's simply too long.

## Master/Detail Table View

Here's a simple table view implemented in RxSwiftWidgets, which then links to a detail view.

> ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-User-List.png) ![List](https://github.com/hmlongco/RxSwiftWidgets/blob/master/Documentation/Resources/Widget-User-Details.png) 

## Sample Code

Let's take a quick walk through the code needed to produce the data-driven user list.

```
struct UserListWidget: WidgetView {

    var viewModel = UserListViewModel()

    func widget(_ context: WidgetContext) -> Widget {

        TableWidget([
            DynamicTableSectionWidget(viewModel.$users) {
                TableCellWidget($0.name)
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

In this case, our widget is a *TableWidget* which generates a UITableView. TableWidgets contain sections, though here we just have one, a *DynamicTableSectionWidget*.

DynamicTableSectionWidgets are just that, dynamic, and here it's bound to an observable array in our view model. Whenever the observable fires with a new list of users, the table rows are automatically updated and regenerated.

The *DynamicTableSectionWidget* initializer also takes a closure that, when called, constructs the interface needed to display each user. Here it's just a simple *TableCellWidget* that shows the user's name.

It also has an *onSelect* modifier that's called whenever the user taps on a cell. As shown, it uses a *navigatior* instance to push a new *[UserDetailsWidget](https://github.com/hmlongco/RxSwiftWidgets/blob/master/RxSwiftWidgetsDemo/Application/Users/UserDetailsWidget.swift)* onto the stack.

The *TableWidget* itself has an *onRefresh* modifier. Here's the closure fires when the view is initially created as well as whenever the user does a pull-to-refresh.

Finally, we have a couple of modifiers that control the navigation bar title and appearance, in addition to informing the constraint system that we want our tableview to fill the entire screen and ignore the safearea.

That's it. That's all of the code for the entire screen ([minus the data loading code in the view model](https://github.com/hmlongco/RxSwiftWidgets/blob/master/RxSwiftWidgetsDemo/Application/Users/UserListWidget.swift)). You didn't create and configure a UITableViewController. No delegates. No datasources.

A complete table view with navigation, dynamic data, and pull-to-refresh, in just 24 lines of code. Interested?

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
