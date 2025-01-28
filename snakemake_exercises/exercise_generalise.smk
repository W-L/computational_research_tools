rule first_step:
    output:
        'data/a_01.txt'
    shell:
        'echo "this is data of a_01" > data/a_01.txt'

rule second_step:
    input:
        'data/a_01.txt'
    output:
        'results/a_01.txt'
    shell:
        'cp data/a_01.txt results/a_01.txt'
