------------------------
Nearby Galaxies Database
------------------------

A database to provide infrastructure for working with ISM, structure,
and star formation in nearby galaxies. 

You are welcome to use this, but should always cite the original
papers (LEDA, EDD, CosmicFlows, etc.). If you are here specifically
for PHANGS stuff, you might prefer to use the PHANGS sample table,
which is built using these codes but is less complicated.

################################################################
HOW TO SET THINGS UP
################################################################

1) Fetch the data files from the web.

Look in the file 'fetch_galbase.py' - this has calls to go get the key
data files from the web. Run this, modify your version of the lookup
functions and just use the thing. This is the best option. The
downside is that you can't modify the contents of the database so
easily.

2) Building the whole thing.

The 'master_script' file lists the steps to reconstruct the whole
database. This is not recommended. I'm not sure whether this has been
successfully run by anyone but me (AKL), and I have not mapped out the
dependencies. That said, it runs fine for me and isn't super
complicated, so it SHOULD work.

################################################################
HOW TO ACCESS THE DATABASE
################################################################

IN IDL

"gal_data" is your interface. It returns a structure containing
distance, size, orientation, etc.

s = gal_data("ngc1234")

Use, e.g., "help, s, /str" to see the contents. From there you are on
your own. The program should be able to handle a vector of galaxies
and return a vector of structures.

IN PYTHON

"gal_data" is also your interface here. Right now it will return a
FITS record read using astropy.

################################################################
HOW TO CONTRIBUTE NEW INFORMATION FOR INDIVIDUAL SYSTEMS
################################################################

We use a system of "override" tables to change the values for any
parameter in the structure. The idea is that override_###.txt will be
read in, comments (#) ignored, and then lines interpretted as:

SOURCE	 FIELD	  VALUE

Where FIELD for SOURCE will be replaced with VALUE. Don't forget to
override the references if needed. These are folded in at creation of
the database (make_gal_base), so you need to rerun that to fold these
in. But you don't need to do anything more upstream than that.

################################################################
HISTORY
################################################################

- Started as "things_galaxies" c. 2008

- Revised to include HERACLES+KINGFISH c. 2010

- Revised to full nearby volume spring 2014

- Python accessor, refactor, upgrades 2016.

- Issues and history now captured in github, this section closed.

- 2018-2019. Large refactor. Automated LEDA call and expanded to all z
  < 0.3 galaxies for master sample. Override tables and survey
  membership now focused on supporting PHANGS. Some physical parameter
  estimation stuff added that should not necessarily be in
  here. Shifted things so that data files live on the web.
