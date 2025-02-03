rule all:
    input:
        expand('results/{sample}_{treatment}.txt', sample=['a',  'b'], treatment=['01', '02'])


rule first_step:
    output:
        'data/{sample}_{treatment}.txt'
    shell:
        'echo "this is data of {wildcards.sample} with treatment {wildcards.treatment}" > {output}'

rule second_step:
    input:
        rules.first_step.output
    output:
        'results/{sample}_{treatment}.txt'
    shell:
        'cp {input} {output}'
