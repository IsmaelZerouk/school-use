-- recommender system for movies that is based on title 
-- creating a table 
CREATE TABLE movies (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text,
Runtime text, UserScore text, Metascore text, scoreCounts text);
-- altering table and adding lexemes title meaning that i want to specifcally want to search on title
ALTER TABLE movies
ADD lexemestitle tsvector;
/* a new colum is added to the movies table, it should in the future contain lexemes generated from the summary field*/ 
UPDATE movies
SET lexemestitle = to_tsvector(title);
/*selecting from movies and picking my favorite movie based on title*/
SELECT * FROM movies where url='the-dark-knight-rises';
/*selecting from movies the title that conctain the the term Batman*/
SELECT title FROM movies WHERE lexemestitle @@ to_tsquery('Batman');
-- adding a new collumum of float4 to the table// this makes it possible to sort and rank the output
ALTER TABLE movies 
ADD rank float4; 
/*updating the movies set to include the title and url of my movie*/
UPDATE movies SET rank = ts_rank(lexemestitle,plainto_tsquery((SELECT title FROM movies WHERE url='the-dark-knight-rises')));
/* selecting the recommendations list based on ran k and url*/
CREATE TABLE recommendationsBasedOntitle AS SELECT url, rank FROM movies ORDER by rank DESC LIMIT 50;
/*seeing that i only get 1 results so i need to lower my treshold*/
 drop table recommendationsBasedOntitle;
/*creating the same table but with a lower treshold and makinh a ranking that goes from 1 to lower and limiting the selection to 50*/
CREATE TABLE recommendationsBasedOntitle AS SELECT title, rank FROM movies WHERE rank >0.01 ORDER by rank DESC LIMIT 50;
/*copying the file and putting it in the directory of RSL with the csv file*/
\copy (SELECT * FROM recommendationsBasedOntitle) to '/home/pi/RSL/top50recommendations_title.csv' with csv;

