# Modify to curl or modify target directory.
import os
print('Fetching galaxy database FITS table from OSU. Placing it in the current directory.')
os.system('wget www.astronomy.ohio-state.edu/~leroy.42/gal_base.fits')
os.system('wget www.astronomy.ohio-state.edu/~leroy.42/gal_base_local.fits')
os.system('wget www.astronomy.ohio-state.edu/~leroy.42/superset_alias.txt')
os.system('wget www.astronomy.ohio-state.edu/~leroy.42/superset_alias.idl')
print('Move it somwhere.')
