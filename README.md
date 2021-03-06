# PayDay
For this project I use MVP architecture with additional objects.
Additional objects includes:
- `Router` to represent navigation between modules
- `UseCase` this is core feature of architecture. The `UseCase` is needed to encapsulate some tasks for working with data, such as: receive, decode, save to DB.
- `Listener` on the other hand, this object is needed to receive data models from DB.
`UseCase` + `Listener` represents unidirectional data flow.

![Solution Architecture Diagram](https://raw.githubusercontent.com/sapa-denis/PayDay/feature/diagrams/Diagrams/PayDay.png)

## Flow Diagrams

#### Sign In
![Sign In](https://raw.githubusercontent.com/sapa-denis/PayDay/feature/diagrams/Diagrams/Sign%20In.png)

#### Sign Up
![Sign Up](https://raw.githubusercontent.com/sapa-denis/PayDay/feature/diagrams/Diagrams/Sign%20up.png)

#### Transaction List
![Transaction List](https://raw.githubusercontent.com/sapa-denis/PayDay/feature/diagrams/Diagrams/Transaction%20List.png)

#### Monthly dashboard
![Monthly dashboard](https://raw.githubusercontent.com/sapa-denis/PayDay/feature/diagrams/Diagrams/Monthly%20Dashboard.png)

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
