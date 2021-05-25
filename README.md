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
- If you tap on any result you will be shown a new page with details of the business such as its name, address, ratings and distance from your current location.

