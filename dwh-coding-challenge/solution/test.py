import json
f = open('1577863800000.json',)
# returns JSON object as 
# a dictionary
data = json.load(f)
  
# Iterating through the json
# list
for i in data['']:
    print(i)
  
# Closing file
f.close()
