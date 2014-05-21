------------------------
Nearby Galaxies Database
------------------------


A code base to provide infrastructure for working with ISM, structure,
and star formation in nearby galaxies.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
PROGRAMS TO ACCESS THE DATABASE
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

"gal_data" is your interface. It returns a structure containing
distance, size, and orientation.

s = gal_data("ngc1234")

Use, e.g., "help, s, /str" to see the contents. From there you are on
your own. The program should be able to handle a vector of galaxies
and return a vector of structures.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
PROGRAMS TO BUILD THE DATABASE
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

make_target_list : extract the target list from the distance file.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
UPDATING THE DATA BASE
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


+++ HOW TO REBUILD THE DATABASE

To add a galaxy: 

(1) In IDL run make_leda_fits, /print_query to generate the LEDA SQL
query. 

(2) Go to http://leda.univ-lyon1.fr/leda/fullsql.html and enter
this. Choose | as a delimiter and NaN as the undefined string.

(3) Download the results to the gal_data directory and rename them to
leda_lvsr3500.txt. Edit the file to comment the header line (with a #)
and remove blank lines.

(4) Run make_leda_fits to generate a binary FITS table out of the LEDA
file.

(5) Get the Milky Way foreground extinction. LEDA ships with SFD98
estimates, but it may still be useful to query IPAC (this also gives
you the newer Schlafly and Finkbeiner 2011 maps). To do this run
"generate_ebv_scratch" and then take the results to:

 irsa.ipac.caltech.edu/applications/DUST/ 



You may need to reconfigure your directory if you do
not choose to go the IPAC route.

(6) Run make_gal_base to generate the binary fits file combining LEDA
and our override files.

+++ DATA FILES


+++ FILES MISSED IN THE LEDA BUILD

(Mostly these lack a velocity)

PGC39145 == DDO113
pgc166101 == KK77


+++ HISTORY

- Started as "things_galaxies" c. 2008

- Revised to include HERACLES+KINGFISH c. 2010

- Revised to full nearby volume spring 2014

+++ TO DO LIST

- Fold in our own value-added products like parameterized rotation
  curves, metallicity, SFR, etc.

- Add a separate list of galaxies to be manually included.

- Python access method.
