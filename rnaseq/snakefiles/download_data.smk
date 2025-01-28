link = 'https://ucloud.univie.ac.at/index.php/s/wEp8nwSy7kQ8ZHz/download/snakemake_rnaseq.tar.gz'


conditions = ['highCO2', 'lowCO2']
samples = ['sample1', 'sample2', 'sample3']
mates = ['1', '2']

rule download_data:
    output:
        expand('data/{condition}_{sample}_{mate}.fastq', condition=conditions, sample=samples, mate=mates),
        genome='resources/Scerevisiae.fasta',
        annotation='resources/Scerevisiae.gtf'
    params:
        download_link=link
    shell:
        '''
        wget {params.download_link} -O snakemake_rnaseq.tar.gz
        tar -xvf snakemake_rnaseq.tar.gz
        rm snakemake_rnaseq.tar.gz
        mv snakemake_rnaseq/* .
        rmdir snakemake_rnaseq/
        '''
