import pandas as pd

#data is a dataframe
data = pd.read_csv('userReviews.csv', sep=';')

print(data.head())

#creating a list and defining the column names
column_names = ['movieName','Metascore_w','Author','AuthorHref','Date','Summary','InteractionsYesCount'
'InteractionsThumbsUp','InteractionThumbDown']

#subset is a next dataframe that has been filtered on your favorite movie
'''subset = pd.DataFrame(columns = column_names)

for movie in range (100):
    if data.movieName.iloc[movie] == 'beach-rats':
      row=data[movie:movie + 1]
      subset.append(row)
      
print(subset)
'''

#create subset of reviews on your favorite movie
subset = data[data.movieName == 'beach-rats']

#Create final dataframe for the recomendation that includes the releative and absolute score
recommendations = pd.DataFrame(columns=data.columns.tolist()+['rel_inc','abs_inc'])

#loop over all the users that watched the same movie that is my favorite

for idx, Author in subset.iterrows():
    #save each author and the ranking he gave to the movie that is chosen
    author = Author [['Author']].iloc[0]
    ranking = Author [['Metascore_w']].iloc[0]
    
    #create a unique dataframe that contains all the movies that where ranked by the selected author
    #based on the highest rank on the movie i like and relate that ranking to an absolute ranking
    #making a filter that looks for author and a metascore with a score that is higher
    filter1 = (data.Author==author)
    filter2 = (data.Metascore_w>ranking)
    
    #extract possible recommendation and calculate the scores
    possible_recommendations = data[filter1 & filter2]
    print(possible_recommendations.head())
    
    #making the ranking possible by dividing the metascore with rank and subtracking it
    possible_recommendations.loc[:,'rel_inc'] = possible_recommendations.Metascore_w/ranking
    possible_recommendations.loc[:,'abs_inc'] = possible_recommendations.Metascore_w - ranking
    
    #putting the outcome of above into recommendation in order to get a result and filling it in
    recommendations = recommendations.append(possible_recommendations)
    
recommendations = recommendations.sort_values(['rel_inc','abs_inc'], ascending=False)
recommendations = recommendations.drop_duplicates(subset='movieName', keep="first")

print(recommendations.head(50))
print(recommendations.shape)
    

