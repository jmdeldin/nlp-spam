Classifying spam profiles on a social network
=============================================

Prerequisites
-------------

- Ruby 1.9.2+
- UNIX-like system
- MySQL (if you need to fetch data)

Preliminary Steps
-----------------

1. Fetch the data from the database (don't do this if you already have a
    `src/data` folder)

        rake data:fetch

2. Fetch the body word lengths

        rake data:length

3. Determine the minimum word length

        rake analyze:length
