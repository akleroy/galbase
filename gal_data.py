import astropy.io.fits as fits

def gal_data(
    name=None,
    all=False,
    data_dir=None,
    found=None,
    ):
    """
    """    

    # http://astropy.readthedocs.org/en/latest/io/fits/#working-with-table-data

    # Location of data

    data_dir = "/users/aleroy/idl/nearby_galaxies/gal_data/"
    fname = data_dir + "gal_base.fits"
    
    hdulist = fits.open(fname)
    tbdata = hdulist[1].data
    
    # Build the list of aliases

    aliases = {}
    
    # Look up the current data
    

    # Return

    pass
