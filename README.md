# PayDay
For this project I use MVP architecture with additional objects.
Additional objects includes:
- `Router` to represent navigation between modules
- `UseCase` this is core feature of architecture. The `UseCase` is needed to encapsulate some tasks for working with data, such as: receive, decode, save to DB.
- `Listener` on the other hand, this object is needed to receive data models from DB.
`UseCase` + `Listener` represents unidirectional data flow.

![Solution Architecture Diagram](https://api.monosnap.com/file/download?id=HExPFBSrYge0mY3LvodQxD1RY9yUHx)

## Flow Diagrams

#### Sign In
![Sign In](https://api.monosnap.com/file/download?id=EIaPKjKuo9egrbZRRmr5GKX2xujIKS)

#### Sign Up
![Sign Up](https://api.monosnap.com/file/download?id=iLNMLn6lic4awfY2p8Bwt8IJdxBsOO)

#### Transaction List
![Transaction List](https://d3dehtdmp2rwcw.cloudfront.net/ms_27834/w6d9ysmoewmKOUypQIlnBwPaWSDUaT/Transaction%2BList.png?Expires=1599980400&Signature=QmL1W5nNK~LUzxtCOH02J~Z8y-Ab8N176OEVpwMoVl57TcTUbcRvD8JtBXo~iOMOq9EcVUXeRzSXIZOdHrUcOQDUzDj6E6Ga5QW8SZ9Vki5kR8WpVap9irFETglIPb7-UVyLCEa~~9l68GtgcqvV5srqQfbsrHCmnOHneKkw~ddJ0s2b8nU6aLzB9uPSjy2W9Kv5GyTl6fSu7pVMAK-hnYfhMPsMeSYovXyVsPMVBDi2TXTQhf9lqv-m021lCDOAkVH0w~0y-wvtq8~v9OHgm07sRM4fMxN-OwzLjuC8Fk9L0vSW6Ge9xWqZ440BMcw~wJJ16xcZCzMvHXYrBZJd8g__&Key-Pair-Id=APKAJBCGYQYURKHBGCOA)

#### Monthly dashboard
![Monthly dashboard](https://api.monosnap.com/file/download?id=wWDCnY0XqmKYWMYj5bxC9wOyiN4Ovh)

## Tech stack
* Swift5
* Core Data
* URLSession
All other parts was written manually without any third-party libraries

* SwiftLint for code style

## Questions
1. I spent about 5-6 days to implement all parts of architecture. I would add validation in SingIn / SignUp modules
2. The moust important feature in latest Swift version is Combine.
But I cant use it in this project, because deployment target is iOS 12.
3. To track down a performance issue in production I would use Firebase system. I have experience in integration and work with this framework.
Also to avoid performance issues we can use several tools:
- common Xcode debug tool. Breakpoints can be parameterised with condition param. + You can add some action into breakpoint.
- Debug view hierarchy to see view layouts
- Debug Memory graph to check object relations and find retain cycles.

Xcode Instruments can help us to check memory leaks, battery and network usage etc. So if previous basic debug tools didn't help, I use Xcode Instruments for deep debugging.

4. I always use `Charles` and `Postman` to check requests/responses.  
5. For API first of all I would add `token` in requests `header`. It will improve security system.
- better to receive dateOfBirth as timestamp value and `first name`/`last name` with snack case:
```
{
  "first_name": "Nadiah",
  "last_name": "Spoel",
  "gender": "female",
  "email": "Tom.Newton@example.com",
  "password": "springs",
  "dob": 1594462210,
  "phone": "1049520521",
  "id": 5
}
```

# Need to implement
- Tests
- Validation on SingIn / SignUp screens
