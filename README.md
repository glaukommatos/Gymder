#  Gymder

## Building & Running

Build the `Gymder` target in Xcode to run either on a simulator or a connected iOS device.

## Testing

You can either run the tests via Xcode's testing UI or on the command line via a command similar to

    xcodebuild test -scheme Gymder -destination 'platform=iOS Simulator,name=iPhone 12 Pro'

## Thoughts

This was a fun toy to make and a great opportunity to practice some view programming and trying
out some design patterns. If you want to know more of my thoughts, I've included a lot of information
in comments at the top of most files.

## Caveats

There's a few things I just haven't done because of time:

- More testing (ideally I would also like to test the lone view model and view controllers).

- No way to reload once you run out of data (although for a while I thought about putting a
  cute animation or something if you actually swiped through everything).
  
- The match view could actually include some details about the match.

- If location permissions change while the app is running (if they are granted when they
  previously were not, specifically), then you'll have to kill and relaunch the app in order
  to see the changes take effect. I have made no effort to listen to these changes, although
  this could be done.
  
## Screenshot 

![Screenshot](https://raw.githubusercontent.com/glaukommatos/Gymder/main/screenshot.gif "Screenshot")
