

set git_root $PWD

mkdir -p projects
cd projects
set root $PWD



while true

    echo search for packages ...
    sleep 3s

    set projects (curl "https://pypi.org/" | sed -nre 's,.*href="/project/([^"]*)/".*,\1,p')

    echo $projects

    for p in $projects

        cd $root
        test -d $p && continue

        mkdir -p $p
        cd $p

        echo 
        echo test $p
        pip download --no-deps $p
        for whl in *.whl
            unzip $whl
        end
        for whl in *.tar.gz
            tar xzvf $whl
        end
        
        find . -type f -not -name "*.py" -delete

        
        #env EXECUTING_TESTFILES=$PWD tox -e py311 || exit

        set test_dir $PWD
        cd $git_root
        echo test $test_dir
        env EXECUTING_SLOW_TESTS=1 EXECUTING_TESTFILES=$test_dir python3.11 tests/test_main.py -k test_more_files
        # or exit

    end
end

