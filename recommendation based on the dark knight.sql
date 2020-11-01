-- recommender system for movies similair to batman the dark knight rises bassed on summary 
-- creating a table 
CREATE TABLE movies (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text,
Runtime text, UserScore text, Metascore text, scoreCounts text);
/* a new colum is added to the movies table, it should in the future contain lexemes generated from the summary field*/ 
UPDATE movies
SET lexemesSummary = to_tsvector(Summary);
/*selecting from movies and picking my favorite movie based on url*/
SELECT * FROM movies where url='the-dark-knight-rises';
/*selecting from movies the summary that conctain the the term action*/
SELECT url FROM movies WHERE lexemesSummary @@ to_tsquery('Action');
-- adding a new collumum of float4 to the table// this makes it possible to sort and rank the output
ALTER TABLE movies 
ADD rank float4; 
/*updating the movies set to include teh summary and url of my movie*/
UPDATE movies SET rank = ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM movies WHERE url='the-dark-knight-rises')));
/* selecting the recommendations list based on rank*/
CREATE TABLE recommendationsBasedOnTheDarkKnight AS SELECT url, rank FROM movies WHERE rank >0.90 ORDER by rank DESC LIMIT 50;
/*seeing that i only get 1 result so i need to lower my treshold*/
 drop table recommendationsBasedOnTheDarkKnight;
/*creating the same table but with a lower treshold and makinh a ranking that goes from 1 to lower and limiting the selection to 50*/
CREATE TABLE recommendationsBasedOnTheDarkKnight AS SELECT url, rank FROM movies WHERE rank >0.01 ORDER by rank DESC LIMIT 50;
/*copying the file and putting it in the directory of RSL with the csv file*/
\copy (SELECT * FROM recommendationsBasedOnTheDarkKnight) to '/home/pi/RSL/top50recommendations_Action_summaryField.csv' with csv;


