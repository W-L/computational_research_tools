


rule hisat_index:
    input:
        genome="resources/Scerevisiae.fasta"
    output:
        genome_index="resources/genome_indices/Scerevisiae_index"
    shell:
        '''
        hisat2-build -p 24 -f {input} {output}
        if [ ! -e "{output}.1.ht2" ]
        then 
            exit 1
        elif
        touch {output}
        '''


