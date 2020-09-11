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
![Sign In](https://www.dropbox.com/s/ca9tqj0ssr0qz6u/Sign%20In.png?dl=0)

#### Sign Up
![Sign Up](https://www.dropbox.com/s/vmsf4llfdnvm84u/Sign%20up.png?dl=0)

#### Transaction List
![Transaction List](https://www.dropbox.com/s/pe5obicy2j8swut/Transaction%20List.png?dl=0)

#### Monthly dashboard
![Monthly dashboard](https://www.dropbox.com/s/twcg6ddfovckle5/Monthly%20Dashboard.png?dl=0)

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
