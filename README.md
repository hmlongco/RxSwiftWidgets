# RxSwiftWidgets ![icon](https://user-images.githubusercontent.com/709283/32858974-cce8282a-ca12-11e7-944b-c8046156290b.png)

 A Declarative Interface Builder for UIKit using Swift 5.1 and RxSwift.

## Introduction

RxSwiftWidgets lets you define your UIKit-based user interfaces using a simple, declarative format similar to that used by SwiftUI and Flutter. RxSwiftWidgets is also based on RxSwift, with means that you have all of the reactive data binding and user interface control and fuctionality you'd expect from such a marriage.

With RxSwiftWidgets interfaces are primarily composed and described using struct-based "widgets" and "modifiers". 

```
    LabelWidget($title)
        .color(.red)
        .font(.title1)
```

Those definitions are used to generate standard UIKit UIViews and UIControls, UIStackViews and other containers, and even the UIViewControllers your application needs to perform a given task.  

They also tend to eliminate the need for Interface Builder Storyboards, Segues, and NIBs, and custom UIViewControllers. All of those things are still there, of course, lying in wait for the times when they're truly needed for some bit of custom functionality.

Like SwiftUI, the goal behind RxSwiftWidgets is to eliminate the hassle behind creating and developing user interfaces. 

Unlike SwiftUI, however, with RxSwiftWidgets you also have the power to reach under the hood at any point in time and  directly work with the generated views and interface elements and tweak them to your hearts content.

## Why RxSwiftWidgets?

With SwiftUI and Combine on the horizon, why use RxSwiftWidgets and RxSwift? Well, the answer to that question actually lies within the question itself: With SwiftUI and Combine **on the horizon**...

SwiftUI is coming, but not yet released. Same for Combine. Perhaps more to the point, SwiftUI and Combine **require** iOS 13. And even when iOS 13 is released, those of us that create professional applications will probably still need to support iOS 12 and iOS 11.

So many of us wouldn't see any of the benefits of doing declarative, reactive programming for one or two **years**. That's simply too long.

## Example

Here's a simple table view implemented in RxSwiftUI.

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
Let's do a quick walkthrough.

Our *UserListWidget* is a *WidgetView*, whose job is to return a single widget container that defines the interface for that view.

In this case, our widget is a *TableWidget* which generates a UITableView. TableWidgets contain sections, though here we just have one, a *DynamicTableSectionWidget*.

DynamicTableSectionWidgets are just that, dynamic, and here it's bound to an observable array in our view model. Whenerver the observable fires with a new list of users, the table rows are automcatically updated and regenerated.

The *DynamicTableSectionWidget* initializer also takes a closure that, when called, constructs the interface needed to display each user. Here it's just a simple *TableCellWidget* that shows the user's name.

It also has an *onSelect* modifier that's called whenever the user taps on a cell. As shown, it uses a *navigatior* instance to push a new *UserDetailsWidget* onto the stack.

The *TableWidget* itself has an *onRefresh* modifier. Here's the closure fires when the view is initially created as well as whenerver they user does a pull-to-refresh.

Finally, we have a couple of modifiers that control the navgiation bar title and appearance, in additoon to informing the constraint system that we want our tableview to fill the entire screen and ignore the safearea.

That's it. That's all of the code for the entire screen (minus the data loading code in the view model). You didn't create and configure a UITableViewController. No delegates. No datasources.

Just 24 lines of code.

## WIP

RxSwiftWidgets is a *beta* release.
