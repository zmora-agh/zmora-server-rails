pipeline {
	agent any
	triggers { pollSCM('H/5 * * * *') }
	stages {
		stage('Install') {
			steps {
				sh './bin/bundle install --path vendor/bundle'
			}
		}
		stage('Lint') {
			steps {
				sh './bin/bundle exec rubocop --require rubocop/formatter/checkstyle_formatter --format RuboCop::Formatter::CheckstyleFormatter -o reports/xml/checkstyle-result.xml || true'
				checkstyle canComputeNew: false, canRunOnFailed: true, defaultEncoding: '', failedTotalAll: '0', healthy: '', pattern: 'reports/xml/checkstyle-result.xml', unHealthy: ''
			}
		}
	}
}
