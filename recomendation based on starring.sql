-- recommender system for movies that is basd on starring
-- creating a table 
CREATE TABLE movies (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text,
Runtime text, UserScore text, Metascore text, scoreCounts text);
ALTER TABLE movies
ADD lexemesStarring tsvector;
/* a new colum is added to the movies table, it should in the future contain lexemes generated from the summary field*/ 
UPDATE movies
SET lexemesStarring = to_tsvector(Starring);
/*selecting from movies and picking my favorite movie based on starring*/
SELECT * FROM movies where Starring='Heath';
/*selecting from all movies the starring that conctain the the term Heath within starring*/
SELECT url, lexemesStaring FROM movies WHERE lexemestitle @@ to_tsquery('Ledger');
-- adding a new collumum of float4 to the table// this makes it possible to sort and rank the output
ALTER TABLE movies 
ADD rank float4; 
/*updating the movies set to include the summary and Starring of my movie*/
UPDATE movies SET rank = ts_rank(lexemesStarring,plainto_tsquery(
(SELECT Starring FROM movies WHERE url='the-dark-knight-rises')));
/* selecting the recommendations list based on rank and Starring*/
CREATE TABLE recommendationsBasedOnStarring AS SELECT url, rank FROM movies WHERE rank >0.99 ORDER by rank DESC LIMIT 50;
/*seeing that i only get 1 result so i need to lower my treshold*/
 drop table recommendationsBasedOnStarring;
/*creating the same table but with a lower treshold and makinh a ranking that goes from 1 to lower and limiting the selection to 50*/
CREATE TABLE recommendationsBasedOnStarring AS SELECT url, rank FROM movies WHERE rank >0.01 ORDER by rank DESC LIMIT 50;
/*copying the file and putting it in the directory of RSL with the csv file*/
\copy (SELECT * FROM recommendationsBasedOnstarring) to '/home/pi/RSL/top50recommendations_starring.csv' with csv;

