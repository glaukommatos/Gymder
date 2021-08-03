#  Gymder

## Building & Running

Build the `Gymder` target in Xcode to run either on a simulator or a connected iOS device.

## Testing

You can either run the tests via Xcode's testing UI or on the command line via a command similar to

    xcodebuild test -scheme Gymder -destination 'platform=iOS Simulator,name=iPhone 12 Pro'

## Thoughts

This was extremely fun to make and I was really happy to have a chance to do custom view programming
and try a bunch of new things out!

In many of the main files in this project, I have included a fair amount of information about my intentions
and decisions in the comments.

I have relied very heavily on the delegate pattern for this implementation. If I were targetting a newer version
of iOS than iOS 11, I would probably use Combine more heavily instead. I haven't played with RxSwift yet,
which might have been an option on that lower target.

## Todos

These are generally things I would like to do to make the app better, but that I need more time to do.

- [ ] Display some match details in the `MatchView`.
- [ ] See about moving what logic I can out of `CardPileView` and into a view model or similar.
- [ ] Add ability to reload once gyms are swiped (need to make some minor changes to `CardPileView` to support this).
- [ ] Improve relationship between `CardPileView` and its data source. I think there's still plenty of room for improvement here.
- [ ] Respond in some sensible way to changes of location service permission without restarting the app.
- [ ] Add aspect ratio constraint for the cards (so iPad doesn't look weird in landscape).
- [ ] Add more tests.

## Screenshot 

<kbd>![Screenshot](https://raw.githubusercontent.com/glaukommatos/Gymder/main/screenshot.png "Screenshot")</kbd>

## Credits

Icons made by [Pixel Perfect](https://icon54.com/) from [Flaticon](https://www.flaticon.com)
