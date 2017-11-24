pipeline {
	agent any
	triggers { pollSCM('H/5 * * * *') }
	stages {
		stage('Install') {
			steps {
				sh './bin/bundle install --path vendor/bundle'
			}
		}
		stage('Prepare database') {
			steps {
				sh './bin/bundle exec rake db:drop db:create db:schema:load RAILS_ENV=test'
			}
		}
		stage('Test') {
			steps {
				sh './bin/bundle exec rake SPEC_OPTS="--format RspecJunitFormatter --out rspec_results/results.xml"'
				junit 'rspec_results/results.xml'
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
