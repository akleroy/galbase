------------------------
Nearby Galaxies Database
------------------------

A code base to provide infrastructure for working with ISM, structure,
and star formation in nearby galaxies.

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
HOW TO ADD NEW INFORMATION FOR INDIVIDUAL SYSTEMS
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
HOW TO REBUILD THE DATABASE
################################################################

The core of the database mostly reskins LEDA with organization and
value added, particularly NED distances and user-supplied
overrides. This is evolving with time, with a main goal being SFR,
Mstar, and structural parameters. Right now the process of creating
the database runs in IDL and is summarized in

master_script

At a high level the process goes like this:

- [Optional] Compile the list of surveys that we are interested in.

- Build LEDA SQL queries, feed these in to hyperleda, and make text
  files. To do this, go to http://leda.univ-lyon1.fr/leda/fullsql.html
  . Choose | as a delimiter and NaN as the undefined string.

- Compile the LEDA text files into FITS files.

- Run the NED query to make sure that we have a distance from NED for
  each target.

- Run the galaxy database constructor (make_gal_base) to put
  everything together. 

- Re-run this constructor to incorporate the latest override values as
  needed.

+++ HISTORY

- Started as "things_galaxies" c. 2008

- Revised to include HERACLES+KINGFISH c. 2010

- Revised to full nearby volume spring 2014

- Python accessor, refactor, upgrades 2016.

- Issues and history now captured in github, this section closed.
