import astropy.io.fits as pyfits
import os
import numpy as np
from pdb import set_trace

def gal_data(names=None, data=None, all=False, data_dir=None, tag=None):

    if not names and not all and not tag:
        print('Need a name to find a galaxy. Returning empty structure')
        return None

    if not data_dir:
        galbase_dir, this_filename = os.path.split(__file__)
        galdata_dir = os.path.join(galbase_dir, "gal_data")

    # READ IN THE DATA
    if data is None:
        dbfile = os.path.join(galdata_dir, 'gal_base.fits')
        hdulist = pyfits.open(dbfile)
        data = hdulist[1].data
        hdulist.close()


    # ALL DATA ARE DESIRED
    if all:
        return data

    # A SPECIFIC SURVEY IS USED
    if tag is not None:
        n_data = len(data)
        keep = np.ones(n_data)
        # survey_file = os.path.join(galdata_dir, 'survey_' + tag.lower() + '.txt')
        # gals = np.genfromtxt(survey_file, dtype='string')

        for i in range(n_data):
            this_tag = data['tags'][i].strip(';').split(';;')
            keep[i] = sum(np.in1d(tag, this_tag))

        if np.sum(keep) == 0:
            print('No targets found with that tag combination.')
            return None

        good_data = data[np.where(keep)]

        return good_data

    # BUILD ALIAS DICTIONARY
    aliases = {}
    fname = os.path.join(galdata_dir, "gal_base_alias.txt")
    f = open(fname)
    f.readline()
    f.readline()
    for line in f:
        s = [temp for temp in line.strip('\n').split(' ')]
        aliases[s[0].replace(' ', '').upper()] = s[1].replace(' ', '').upper()

    # NAME OR NAMES of GALAXIES
    if type(names) == str:
        names = [names]
    keep = np.zeros(len(data), dtype=bool)

    # SEARCH FOR GALAXIES
    for name in names:
        name_a = aliases[name.replace(' ', '').upper()]
        ind = data.field('NAME') == name_a

        if sum(ind) == 0:
            print('No match for ' + name)
        else:
            keep += ind

    return data[keep]