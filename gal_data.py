import os
import numpy as np
import pandas as pd
from astropy.table import Table


def gal_data(names=None, pgc=None, keep_length=False,
             all=False, tag=None, tag_type='outer',
             data=None, data_dir='', full=False,
             force_gen_pkl=False, quiet=True):

    if names is None and pgc is None and tag is None and not all:
        if not quiet:
            print('Need a name or a PGC number to find a galaxy, '
                  'or a tag to find galaxies in a specific survey. ')
        return Table()

    use_pgc = (names is None) and (pgc is not None)

    if keep_length:
        how = 'left'
    else:
        how = 'inner'

    if not data_dir:
        galbase_dir, _ = os.path.split(__file__)
        data_dir = os.path.join(galbase_dir, "gal_data")

    # READ IN THE DATA
    if data is None:
        if full:
            pklfile = os.path.join(data_dir, 'gal_base.pkl')
            fitsfile = os.path.join(data_dir, 'gal_base.fits')
        else:
            pklfile = os.path.join(data_dir, 'gal_base_local.pkl')
            fitsfile = os.path.join(data_dir, 'gal_base_local.fits')
        if (not os.path.isfile(pklfile)) or force_gen_pkl:
            print('Generating PKL file for the galaxy database '
                  '(this is just a one-time operation)')
            df_original = Table.read(fitsfile).to_pandas()
            # convert the 'TAGS' field into seperate bool-type fields
            from glob import glob
            surveyfile = os.path.join(data_dir, 'survey_*.txt')
            flist = glob(surveyfile)
            tags = []
            for f in flist:
                tags += [f[len(data_dir)+8:-4].upper()]
                df_original['TAG['+tags[-1]+']'] = False
            def convert_tags(s, tags):
                for tag in tags:
                    if (';'+tag+';').encode() in s['TAGS']:
                        s['TAG['+tag+']'] = True
                return s
            df = df_original.apply(convert_tags, axis=1, args=(tags,),
                                   result_type='broadcast')
            for col in df_original.columns:
                df[col] = df[col].astype(df_original[col].dtype)
            for t in tags:
                df['TAG['+t+']'] = df['TAG['+t+']'].astype('?')
            df.to_pickle(pklfile)
        if not quiet:
            print('Reading PKL file for galaxy database')
        df = pd.read_pickle(pklfile)
    else:
        df = pd.DataFrame(data)

    # ALL DATA ARE DESIRED
    if all:
        return Table.from_pandas(df)

    # TARGETS WITH SOME TAGS ARE DESIRED
    if tag is not None:
        tags = np.atleast_1d(tag)
        if tag_type == 'inner':
            mask = np.ones(len(df)).astype('?')
        elif tag_type == 'outer':
            mask = np.zeros(len(df)).astype('?')
        else:
            raise ValueError('Unknown tag selection type: {}'
                             ''.format(tag_type))
        for t in tags:
            if tag_type == 'inner':
                mask &= df['TAG['+t.upper()+']']
            else:
                mask |= df['TAG['+t.upper()+']']
        return Table.from_pandas(df[mask])

    # SPECIFIC TARGETS ARE DESIRED
    if use_pgc:
        df_pgc = pd.DataFrame(np.squeeze(pgc).astype('int'),
                             columns=['PGC'])
    else:
        pklfile = os.path.join(data_dir, 'superset_alias.pkl')
        if (not os.path.isfile(pklfile)) or force_gen_pkl:
            print('Generating PKL file for the alias dictionary '
                  '(this is just a one-time operation)')
            txtfile = os.path.join(data_dir, 'superset_alias.txt')
            df_dict = pd.read_csv(txtfile, sep=' ', skiprows=2,
                                   names=['alias', 'PGC'])
            df_dict.to_pickle(pklfile)
        else:
            if not quiet:
                print('Reading PKL file for galaxy aliases')
            df_dict = pd.read_pickle(pklfile)
        df_names = pd.DataFrame(np.atleast_1d(names),
                                columns=['alias'])
        if not quiet:
            print('Translating aliases to PGC names')
        df_pgc = pd.DataFrame(pd.merge(df_names, df_dict,
                                       on='alias', how=how)['PGC'])
        if keep_length:
            df_pgc['PGC'] = df_pgc['PGC'].fillna(-1).astype(df_dict['PGC'].dtype)

    if not quiet:
        print('Extracting corresponding rows from the database')
    t_desired = Table.from_pandas(pd.merge(df_pgc, df,
                                           on='PGC', how=how))
    if keep_length:
        t_desired['PGC'].mask = (t_desired['PGC'] == -1)
    return t_desired
