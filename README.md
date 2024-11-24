# Crummy-Map-App

Demonstrates how to build a fully-accesible iOS app with Swift 5

### Demo Video

https://user-images.githubusercontent.com/32881455/122994693-545a4f00-d36e-11eb-8c54-9f833eab134a.mp4

#### Fully Accessible, with support for dynamic font sizing, and legible voice-over

![Screen Shot 2021-06-22 at 4 18 10 PM](https://user-images.githubusercontent.com/32881455/123000712-89b66b00-d375-11eb-9f0a-6bad237010ac.png)

#### Request Throttling

```swift
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.dataManager.search(for: term) { result in
                let vc = searchController.searchResultsController as? SearchResultsViewController
                switch result {
                case .success(let searchResults):
                    if searchResults.isEmpty {
                        vc?.showNoResults()
                    } else {
                        vc?.show(results: searchResults)
                    }

                case .failure(let error):
                    vc?.show(error: error.localizedDescription)
                }
            }
        }
        
        // Throttle requests to only one per second
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)
```

#### Better Response Management

```swift
     func search(for term: String, completion: @escaping (Result<SearchResponse, SearchError>) -> Void) {
        let url = baseURL.appendingPathComponent("geocode/v1/json")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "q", value: term)
        ]

        // The order of the responses is not guaranteed, so if a request is already in progress, we should
        // cancel it before starting a new one. This is especially important in low-bandwith environments.
        activeSearchTask?.cancel()
        
        let request = URLRequest(url: components.url!)
        activeSearchTask = perform(request: request, completion: parseResponse(completion: completion))
    }
```

#### UX with helpful user feedback

![Screen Shot 2021-06-22 at 3 06 18 PM](https://user-images.githubusercontent.com/32881455/122996229-3d1c6100-d370-11eb-996b-4c4618bc8a27.png)
![Screen Shot 2021-06-22 at 3 06 43 PM](https://user-images.githubusercontent.com/32881455/122996231-3db4f780-d370-11eb-9be8-5f20d07a9bcd.png)

