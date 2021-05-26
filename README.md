In this sample project, we use Yelp's API to search for business establishments around user's location and show a list and details and map for each business. 

## How to run this porject
- Clone the project on your mac. 
- Open the project using the latest version of Xcode.
- Add your Yelp `API_KEY` in the file within the project that is called `YelpAPI.plist`
     - Yelp `API_KEY` can be obtained by following the instructions at: https://www.yelp.com/developers/documentation/v3/authentication
     - We are using the authentication method that is described in the above link as "Authenticate API calls with the API Key"

## What to expect when running this porject
- The app prompts you for access to location services on your iOS device. 
- You should see a text box that you can enter any search terms for any business you are looking for. For example you can search for "Donuts" 🍩 , "Pizza" 🍕 or "Dentist" 🦷.
- Tap the Search button to see the results. 
- If you tap on any result you will be shown a new page with details of the business such as its name, address, ratings and distance from your current location. You will also see a map that shows your location (blinking blue circle) and a pin on top of the business location.  

## How it works
- This app takes advantage of one of Yelp APIs `/businesses/search` by passing parameters `latitude`, `longitude`, and `term`. By keeping the rest of parameters as default values, this API returns a list of businesses that are within certain vicinity of the location (`latitude`, `longitude`) and matches the search `term`, if there is one passed in. 
