Nearby Galaxies Database

A code base to provide infrastructure for working with ISM, structure,
and starf formation in nearby galaxies.

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

To add a galaxy: 

(1) place an entry with a distance in the "table_dist.txt" file. By
default, I suggest using the median distance from NED.

(2) Generate a new target list with "make_target_list"

(3) Go to hyperleda and choose to "Define a Sample"

(4) Generate the following new files:

leda_position.txt - columns are al2000, de2000, celposj(pgc)

leda_morphology.txt - type, bar, ring, multiple, compactness, t, e_t

leda_diameter.txt - logd25, e_logd25

leda_orient.txt -  logr25, e_logr25, pa, incl

Alternatively, you might get just the values for your new targets and
place them in the files by hand (with appropriate delimiters). Order
doesn't matter. See the gal_data file for the readcol calls.

There are options to overwrite the LEDA parameters and to add to the
"value-added" parameters. These are still being revised but will be
updated here.

(5) Get the Milky Way foreground extinction. There are two ways to do
this. If you have the SFD IDL codebase installed, then you can convert
your targets to galactic and extract measurements there. To use the
more recent Schlafly and Finkbeiner maps, the best option that I have
found is to go to irsa.ipac.caltech.edu/applications/DUST/ and upload
a list of objects. The program "generate_ebv" will try to do both of
these for you. You may need to reconfigure your directory if you do
not choose to go the IPAC route.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
DATA FILES
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

In the gal_data/ directory there are a number of text files holding
the information on our galaxy sample. These are:

*** table_dist.txt

The parent file for the galaxy list. Holds a distance in Mpc for each
galaxy. This is used to make the target list. Convention is lower case
galaxy names.

*** alias.txt

File holding aliases. Not every galaxy needs an entry, but any name in
the second column should map back to the first column.

*** target_list.txt

A _generated_ file holding the names of all targets. Extracted from
the table_dist.txt file.
