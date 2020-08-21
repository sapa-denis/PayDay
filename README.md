# PayDay

## Tech stack
* Swift5
* Core Data
* URLSession
All other parts was written manually without any third-party libraries

* SwiftLint for code style

## Questions
1. I spent at least 84h to implement all parts of architecture. I would add validation in SingIn / SignUp modules
2. The moust important feature in latest Swift version is Combine.
But I cant use it in this project, because deployment target is iOS 12.
3. To track down a performance issue in production I would use Firebase system. I have experience in integration and work with this framework.
4. I always use `Charles` and `Postman` to check requests/responses.  
5. For API first of all I would add `token` in requests `header`. It will improve security system.
- better to receive dateOfBirth as timestamp value and `first name`/`last name` with snack case:
`<{
  "first_name": "Nadiah",
  "last_name": "Spoel",
  "gender": "female",
  "email": "Tom.Newton@example.com",
  "password": "springs",
  "dob": 1594462210,
  "phone": "1049520521",
  "id": 5
}>`

# Need to implement
- Tests
- Validation on SingIn / SignUp screens
