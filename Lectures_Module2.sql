/* EdX.org - DAT201x - Module 2 - Lecture Queries */
/* Returns non-unique results for whole data set, so one color result for each row in the data set */
/* ALL is completely optional, but included here to show where keyword DISTINCT goes in later example */
SELECT ALL Color
FROM SalesLT.Product;

/* Returns distinct results for data set, removing duplicates */
SELECT DISTINCT Color
FROM SalesLT.Product;
