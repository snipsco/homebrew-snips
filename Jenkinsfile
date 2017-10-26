//def git_user_email = "tobor.spins@snips.net"
//def git_user_name = "Tobor"

def git_user_email =  'jenkins@snips.ai'
def git_user_name =  'Jenkins'

def ssh_sh(String action) {
    sh "ssh-agent sh -c 'ssh-add ; $action'"
}

def formulae = [
    "snips-analytics.rb",
    "snips-asr-google.rb",
    "snips-asr.rb",
    "snips-audio-server.rb",
    "snips-dialogue.rb",
    "snips-hotword.rb",
    "snips-injection.rb",
    "snips-nlu.rb",
    "snips-skill-server.rb",
    "snips-tts.rb",
    "snips-watch.rb",
]

node("macos-elcapitan-aws") {
    properties([
        parameters([
            string(defaultValue: 'NONE', description: 'tag to build', name: 'tag'),
        ])
    ])

    stage('Checkout') {
        deleteDir()
        checkout scm
    }

    stage('Release') {
        def platformTag = "${params.tag}"
        def formulaPaths = formulae.collect { formula -> "Formula/${formula}" }.join(" ")

        ssh_sh """
            git config --global user.email ${git_user_email}
            git config --global user.name ${git_user_name}

            git clone --branch $platformTag --depth 1 git@github.com:snipsco/snips-platform.git
            revision=\$(cd snips-platform && git rev-parse $platformTag)

            .ci/bump.sh $platformTag \$revision \
                Formula/snips-platform-common.rb \
                $formulaPaths

            .ci/make_bottles.sh Formula/snips-platform-common.rb
            .ci/make_bottles.sh $formulaPaths

            .ci/rename_bottles.sh \$(find . -name '*.bottle.json')

            .ci/merge.sh \$(find . -name '*.bottle.json')

            .ci/upload_bottles.sh

            git checkout master
            git commit -am "[Release] ${platformTag}"
            git push origin master
        """
    }
}

