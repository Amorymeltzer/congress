### Todo
- Figure out how this works...
- Map out gameplan for rewrite
- R or python for graphs?  Need to get in there
- In R can maybe use Rcartogram http://stackoverflow.com/questions/32406216/population-weighted-polygon-distortion
- Maybe start from R and desired graphs, work backwards to the data needed, then to the scripts

- 2000 election uses numbers from 1990, of course.  Tricky.

- Check hunt hill algorithm, etc, for accuracy
- Convert to .csv?  Or all .tsv?
- massHuntHill - Divide by Wyoming to get some measure of divisibility
- ie if everything divisible...
- Test suite ie confirm calculations match actual

### Gameplan
- Parse census data to count reps per state
- Parse per state election data
- Keep a record of actual results to compare to
- For every year and every size...
- Some metric for difference from actual
- How to get a three-dimensional graph?  Probably need python/R there...
- Option simulate senate increase
- 60k per seat courtesy of Madison's proposed 12 amendments
- Show changes in house, senate distribution, scores, etc.
- Maybe one of those tweaked US maps by size, etc.

- Check out http://www.arilamstein.com/blog/2015/08/13/mapping-historic-us-presidential-election-results/ and http://www.arilamstein.com/blog/2016/03/21/mapping-election-results-r-choroplethr/ and maybe http://www.arilamstein.com/blog/2016/04/18/r-election-analysis-contest-results/
