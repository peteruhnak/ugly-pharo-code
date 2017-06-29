#!/usr/bin/env bash

set -eu


# SMALLTALK_CI_IMAGE is an env variable available from SmalltalkCI
# SMALLTALK_VM currently doesn't work, so that's why I search for it by hand
SMALLTALK_VM="$(find $SMALLTALK_CI_VMS -name pharo -type f -executable | head -n 1) --nodisplay"

run_coverage() {
	$SMALLTALK_VM $SMALLTALK_CI_IMAGE eval "
pkg := 'UglyPackage' asPackage.

pkg classes do: [ :cls |
	Transcript logCr: cls name.
	cls critiques do: [ :crit |
		Transcript
			tab; log: '* '; logCr: crit description
	].

	Transcript
		tab; logCr: 'methods:'.
	cls methods do: [ :meth |
		Transcript
			tab; tab; logCr: meth selector.
		meth critiques do: [ :crit |
			Transcript
				tab; tab; tab; log: '* '; logCr: crit description
		]
	]
]."
}

main() {
	run_coverage
}

main