# TMEvents

TMEvents is a simple mobile app that exercises the Discovery REST-ful API from TicketMaster to show events throw a search bar by keyword.

## Installation

Only download the Zip or clone the repo and go to Package Dependencies section two fingers clic and select update package


## Usage
It's very easy to use only introduce a keyword to search by Artist, event or venue, then you'll get the events related to that keyword.


## Description

For this simple App I decided to store the API key in a config plist file (added to git ignore) for security and not expose the API key as public.
For the architecture I've decided to use MVVM with combine for bindings and UIKit instead of SiwftUI because it's the first time I'm using combine along with UIKit insrtead of SwiftUI so I think it's a great opportunity to work with both.

I created a simple but very reusable network layer for the responses so the app is scalable to keep adding more services. I'm using programatically views instead o XIBs because it's more readable and it's a bit faster in runtime. 

I added a network monitor to catch when user has or not netowrk connection and disable or enable the search bar and fire an alert when user has lost the connection.

I decided to use a simple design that is useful, compatible with any device size and with dark mode. I did not focus to much in the UI (I added comic Sans font).

Basically it's a simple App but I did focus to do main components of the app reusable and easy to test.

I only added one external dependency that is Kingfisher to load images with url because it's the best option to manage the dowload of the content and it manage cache automatically so the optimization is really good.

## License

[MIT](https://choosealicense.com/licenses/mit/)
