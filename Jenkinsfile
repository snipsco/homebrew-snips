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
            cd snips-platform
            revision=\$(git rev-parse $platformTag)
            cd ..

            ./make.sh $platformTag \$revision "Formula/snips-platform-common.rb"
            ./make.sh $platformTag \$revision ${formulaPaths}
            ./make.sh $platformTag \$revision "Formula/snips-voice-platform.rb"

            git commit -am "[Release] ${platformTag}"
            git push origin master
        """
    }
}

