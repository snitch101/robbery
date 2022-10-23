-- Keep a log of any SQL queries you execute as you solve the mystery.
-- July 28 2021 Humphrey street
-- Get id and description of the crime scene
SELECT description FROM crime_scene_reports WHERE year = 2021 AND month = 7 AND day = 28 AND street = "Humphrey Street";

--Get interviews conducted on the day
SELECT transcript, name, id FROM interviews WHERE year = 2021 AND month = 7 AND day = 28;

--Look for plate numbers of cars that left parking lot within 10 minutes of theft
SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25;

--find the id of the people with the licence plate numbers above
SELECT DISTINCT people.name, people.phone_number, people.passport_number, people.license_plate
FROM people
JOIN bakery_security_logs
ON people.license_plate = bakery_security_logs.license_plate
WHERE bakery_security_logs.license_plate
IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25);

--use ids of people to find account numbers
SELECT bank_accounts.account_number
FROM bank_accounts
JOIN people
ON people.id = bank_accounts.person_id
WHERE bank_accounts.person_id
IN (SELECT DISTINCT people.id
FROM people
JOIN bakery_security_logs
ON people.license_plate = bakery_security_logs.license_plate
WHERE bakery_security_logs.license_plate
IN (SELECT license_plate
FROM bakery_security_logs
WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25));

--use bank accounts to find people who withdrew
SELECT DISTINCT atm_transactions.account_number FROM atm_transactions JOIN bank_accounts ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.atm_location = "Leggett Street" AND atm_transactions.transaction_type = "withdraw" AND atm_transactions.account_number IN (SELECT bank_accounts.account_number FROM bank_accounts JOIN people ON people.id = bank_accounts.person_id WHERE bank_accounts.person_id IN (SELECT DISTINCT people.id FROM people JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate WHERE bakery_security_logs.license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25)))

--use the accounts of people who withdrew to fiind their phone numbers
SELECT DISTINCT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.account_number IN (SELECT DISTINCT atm_transactions.account_number FROM atm_transactions JOIN bank_accounts ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.atm_location = "Leggett Street" AND atm_transactions.transaction_type = "withdraw" AND atm_transactions.account_number IN (SELECT bank_accounts.account_number FROM bank_accounts JOIN people ON people.id = bank_accounts.person_id WHERE bank_accounts.person_id IN (SELECT DISTINCT people.id FROM people JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate WHERE bakery_security_logs.license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25))))

--find the phone numbers of the people
SELECT people.phone_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE people.id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.account_number IN (SELECT DISTINCT atm_transactions.account_number FROM atm_transactions JOIN bank_accounts ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.atm_location = "Leggett Street" AND atm_transactions.transaction_type = "withdraw" AND atm_transactions.account_number IN (SELECT bank_accounts.account_number FROM bank_accounts JOIN people ON people.id = bank_accounts.person_id WHERE bank_accounts.person_id IN (SELECT DISTINCT people.id FROM people JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate WHERE bakery_security_logs.license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25)))))

--find the calls that were on the day and less than one minute
SELECT DISTINCT phone_calls.caller FROM phone_calls JOIN people ON phone_calls.caller = people.phone_number WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60 AND phone_calls.caller IN (SELECT people.phone_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE people.id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.account_number IN (SELECT DISTINCT atm_transactions.account_number FROM atm_transactions JOIN bank_accounts ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.atm_location = "Leggett Street" AND atm_transactions.transaction_type = "withdraw" AND atm_transactions.account_number IN (SELECT bank_accounts.account_number FROM bank_accounts JOIN people ON people.id = bank_accounts.person_id WHERE bank_accounts.person_id IN (SELECT DISTINCT people.id FROM people JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate WHERE bakery_security_logs.license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25))))))

--find the passport numbers of the owners of the returned phone calls
SELECT DISTINCT people.passport_number FROM people JOIN phone_calls ON phone_calls.caller = people.phone_number WHERE phone_calls.caller IN (SELECT DISTINCT phone_calls.caller FROM phone_calls JOIN people ON phone_calls.caller = people.phone_number WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60 AND phone_calls.caller IN (SELECT people.phone_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE people.id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.account_number IN (SELECT DISTINCT atm_transactions.account_number FROM atm_transactions JOIN bank_accounts ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.atm_location = "Leggett Street" AND atm_transactions.transaction_type = "withdraw" AND atm_transactions.account_number IN (SELECT bank_accounts.account_number FROM bank_accounts JOIN people ON people.id = bank_accounts.person_id WHERE bank_accounts.person_id IN (SELECT DISTINCT people.id FROM people JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate WHERE bakery_security_logs.license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25)))))))

--find the airport code for fiftyville
SELECT id FROM airports WHERE city = "Fiftyville"

--find the earliest flight for the next day
SELECT id FROM flights WHERE year = 2021 AND month = 7 AND day = 29 AND origin_airport_id IN (SELECT id FROM airports WHERE city = "Fiftyville") ORDER BY hour, minute LIMIT 1

--find the passenger on the ealiest flight the next day
SELECT passengers.passport_number FROM passengers JOIN flights ON flights.id = passengers.flight_id JOIN people ON people.passport_number = passengers.passport_number WHERE passengers.flight_id IN (SELECT id FROM flights WHERE year = 2021 AND month = 7 AND day = 29 AND origin_airport_id IN (SELECT id FROM airports WHERE city = "Fiftyville") ORDER BY hour, minute LIMIT 1) AND passengers.passport_number IN (SELECT DISTINCT people.passport_number FROM people JOIN phone_calls ON phone_calls.caller = people.phone_number WHERE phone_calls.caller IN (SELECT DISTINCT phone_calls.caller FROM phone_calls JOIN people ON phone_calls.caller = people.phone_number WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60 AND phone_calls.caller IN (SELECT people.phone_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE people.id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.account_number IN (SELECT DISTINCT atm_transactions.account_number FROM atm_transactions JOIN bank_accounts ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.atm_location = "Leggett Street" AND atm_transactions.transaction_type = "withdraw" AND atm_transactions.account_number IN (SELECT bank_accounts.account_number FROM bank_accounts JOIN people ON people.id = bank_accounts.person_id WHERE bank_accounts.person_id IN (SELECT DISTINCT people.id FROM people JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate WHERE bakery_security_logs.license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25))))))))

--name of thief
SELECT name FROM people WHERE passport_number IN (SELECT passengers.passport_number FROM passengers JOIN flights ON flights.id = passengers.flight_id JOIN people ON people.passport_number = passengers.passport_number WHERE passengers.flight_id IN (SELECT id FROM flights WHERE year = 2021 AND month = 7 AND day = 29 AND origin_airport_id IN (SELECT id FROM airports WHERE city = "Fiftyville") ORDER BY hour, minute LIMIT 1) AND passengers.passport_number IN (SELECT DISTINCT people.passport_number FROM people JOIN phone_calls ON phone_calls.caller = people.phone_number WHERE phone_calls.caller IN (SELECT DISTINCT phone_calls.caller FROM phone_calls JOIN people ON phone_calls.caller = people.phone_number WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60 AND phone_calls.caller IN (SELECT people.phone_number FROM people JOIN bank_accounts ON bank_accounts.person_id = people.id WHERE people.id IN (SELECT DISTINCT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.account_number IN (SELECT DISTINCT atm_transactions.account_number FROM atm_transactions JOIN bank_accounts ON bank_accounts.account_number = atm_transactions.account_number WHERE atm_transactions.atm_location = "Leggett Street" AND atm_transactions.transaction_type = "withdraw" AND atm_transactions.account_number IN (SELECT bank_accounts.account_number FROM bank_accounts JOIN people ON people.id = bank_accounts.person_id WHERE bank_accounts.person_id IN (SELECT DISTINCT people.id FROM people JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate WHERE bakery_security_logs.license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit" AND minute < 25)))))))))

--thief escaped to
SELECT city FROM airports JOIN flights ON airports.id = flights.destination_airport_id WHERE flights.id IN (SELECT id FROM flights WHERE year = 2021 AND month = 7 AND day = 29 AND origin_airport_id IN (SELECT id FROM airports WHERE city = "Fiftyville") ORDER BY hour, minute LIMIT 1)

--accomplis is
SELEct phone_number from people where name = "Bruce"

select receiver from phone_calls where caller in ()

