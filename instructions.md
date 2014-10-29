### Stats for a given congressional size

#### States, Electors, Average district size
perl huntHill.pl 435 2010_census.csv | sort -rnk 2 | head -n 50 | cut -f 2,3 > current.tsv 

#### Convert the file above into some basic stats
perl avgDistSize.pl current.tsv


### Tabulate electors for a range of size
#### House size, electors per state, avg(?)
perl massHuntHill.pl 435 535 2010_census.csv > sizes.tsv


### Create some fake data to simulate different election results
#### Election year, electors per state
perl fakeData.pl 2010_census.csv > voting_data.tsv

### Simulate the election given the above fake data and a list of house sizes
perl electionSim.pl voting_data.tsv sizes.tsv
