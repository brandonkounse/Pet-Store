# Petstore

**Petstore** is a full-stack application that serves as both a web app and a backend API.

The tech stack is as follows:
- Ruby on Rails v. 7.0.4.3
- PostgreSQL v. 16.0
- Redis-Server v. 7.2.1

## Ruby on Rails

**Ruby on Rails** is used as both the backend API as well as the web interface for the Petstore. All routes are `RESTful`, supporting the four `CRUD` operations for interacting with the database.

## PostgreSQL

**PostgreSQL** is used for database persistance.

## Redis

**Redis** is used as the cache store for Rails. Pets and store orders are cached to limit database queries.

## Docker

**Docker** and docker-compose are used to containerize the application and coordinate the image services to run together. To start the application, while in the app's root directory, run:

```bash
docker build -t <petstore> .
```

From there, the `docker-compose.yml` file is ran to spin up PostgreSQL and Redis.

```bash
docker compose up --build
```

The final step to have the app successfully run is to run the following command:

```bash
docker compose run web rake db:migrate
```

This ensures that all of the migrations are successfully ran before the server is launched. A database seed can optionally be used to experiment with the features of the petstore using:

```bash
docker compose run web rake db:seed
```

## Interacting with the Storefront

By default, the index page of the web app is the storefont. A pet can be clicked on to place an order with a valid email address. Once the pet is ordered, the order can also be cancelled from the same screen.

If submitting the order through `-cURL JSON`, the `POST`, `PUT`, and `DELETE` requests must have the Rails generated authenticity token in the header of the request. This measure is to protect against Cross Site Request Forgery. Here is an example request:

```bash
curl --location 'http://localhost:3000/store/order' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'X-CSRF-Token: po1boAk-btoORMF3cotyqyyf4tpVSN-EmJDuNis2Haci_7YpL6XU-PetOJ8jLoTu9Wka56ehl5BLvhucW1CkGw' \
--header 'Cookie: _petstore_session=q8Aiwftnw372HnrBCVTtev9dLR0IuI12RNPtpGRUZxp%2Fh8rkShqf05zKDLpSTcgbfyx9wynvDR69UeEUaE7LxmyTXDLL96GFWbRDtsPbeQyHqxsGxFBMD5XpTszTml62Bnsen0DbUgEX7TKPdSWKsNej390aBvycFVDC0ra5RUyjnrpHR0lBBWs%2FUdcQ4tq2NqJ%2FB3r2DlY%2BKcZKzMFTRu74%2Fni9pgFSClWow9n6Z3jvBD0ZC%2F7jeuhD9hkywsGOwzbU8reDgLXC8VITo7mOhq3JSp8f5gWDOQ%3D%3D--0FK1WNjtpa%2Bfszg1--dKTN9WeGSzBfpOfJw8D9uQ%3D%3D' \
--data-raw '{"order": { "user_email": "test@email.com", "pet_id": "1" }}'
```

Which will return:

```JSON
{
    "id": 1,
    "order_confirmation_number": "7KIVBZCVFZ",
    "order_date": "2023-10-10",
    "user_email": "test@email.com",
    "created_at": "2023-10-10T04:21:59.206Z",
    "updated_at": "2023-10-10T04:21:59.206Z",
    "pet_id": 1
}
```

## Interacting with the Admin Site

At the top of the storefront is a `login` link. For this sample web app, create a user id and password to sign-in. Once autheticated, a new link will be available to redirect to the pet management part of the web app. From here, pets can be added, edited, or deleted.

Like with the storefront, if using `-cURL JSON` and a `POST`, `PUT`, or `DELETE`, the Rails authenticity token must be submitted via the `cURL` header.

To sign-up, a `POST` request is sent to /users with an example such as:

```bash
curl --location 'http://localhost:3000/users/' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'X-CSRF-Token: DxlLW45h01Qk4FfGj2-NbytfTdFZ_Hsp8dn2BfsmSwhd64iy5-VueVZ2LuFuihI9j0wo5dEJzWcZHxadsCkAXQ' \
--header 'Cookie: _petstore_session=L3DrqhmfP81f%2BAH8yGDJgleaQyORHjUxtGJg0%2F0gJfe6swBiZM6txS923NxZXipXloT7LM%2FHEpE6SH9mj%2BngTZApyt8%2FkJHyv%2FqCzcpxhq8%2F7l%2FlA4SYQ30EhPJ9hdrhegk%2B0Z8W4LaL9qYH%2BPgwirkzgZYaAenNFoiz0th6l9Oc%2BHL%2FsjLOad8fpLW9WjUB0crU%2FvIjsgK%2FNLzTaF4tojB0%2FIOmTI16GN%2BlKsGkH6gcrg3QAq%2F%2FmsRT8ggJPBspBnmKyJDGeqGlVp1KTqHBbbOZw%2FUi%2F5Ula%2BIDf4O1AZcxhbhFJ5Z0hsu7YSY%2B3YmkbXDUeo0uucyWsPfXLkQNk4ltqWMYhQEKBEo4R8z2g%2FKSvMb1akmxSu9IPAe%2BkXPzsFvFBcSHZDGJ--TdE91R1YXX6hXQ9S--ErJRgl1eNcefi9SMEsp8PQ%3D%3D' \
--data-raw '{"user": { "email": "example@email.com", "password": "test1234!", "password_confirmation": "test1234!" }}'
```

Logging in is similar, but the email and password are instead sent to `/users/sign_in`.

---

Once authenticated, the signed in user can add, edit, or delete pets as necessary. A `JSON` request can be submitted with the following criteria for adding and editing:

```JSON
{
    "pet":
    {
        "name": "example",
        "species": "lorem",
        "age": 42,
        "price": 1.99
    }
}
```

`DELETE` is achieved by submitting a `DELETE` request to `/pets/{pet_id}`.

## Image Credits

All pet images are from http://www.pexels.com and are accredited to these photographers:
- Animal: Dog,        Photographer: Pixabay
- Animal: Cat,        Photographer: Ihsan Adityawarman
- Animal: Ferret,     Photographer: Verina
- Animal: Monkey,     Photographer: DSD
- Animal: Parrot,     Photographer: Couleur
- Animal: Guinea Pig, Photographer: Jakson Martins
- Animal: Lizard,     Photographer: Sameera Madusanka
- Animal: Gerbil,     Photographer: Robbie Owenwahl
- Animal: Rabbit,     Photographer: Lil Artsy
- Animal: Hamster,    Photographer: Sharon Snider
- Animal: Nil,        Photographer: Pixabay
