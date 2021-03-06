Class {
	#name : #SpecOfExpectedObjectSenderTests,
	#superclass : #TestCase,
	#category : 'Mocketry-Specs-Tests'
}

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testDescription [
	
	| spec |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).

	spec where description should equal: '#object should be returned from #receiver selector'
]

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testFailedValidationWhenNobodyReturnedObjectAndRequiredSenderWasNotOccurred [
	
	| spec message result |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).

	message := MockOccurredMessage receiver: #receiver2 selector: #selector.
	message result: #otherResult asOccurredMessageResult.
	
	result := spec validate: { message }.
	
	result should be isFailure.
	result where description should equal: '#object was not returned by anybody but it should be #receiver selector'
]

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testFailedValidationWhenRequiredSenderRaisedErrorAndNobodyReturnedGivenObject [
	
	| spec message result |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).

	message := MockOccurredMessage receiver: #receiver selector: #selector.
	message result: (MockOccurredExceptionSignal exception: #exc).
	
	result := spec validate: { message }.
	
	result should be isFailure.
	result where description should equal: '#object was not returned by anybody but it should be #receiver selector'
]

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testFailedValidationWhenRequiredSenderReturnedAnotherObjectAndNobodyReturnedGivenObject [
	
	| spec message result |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).

	message := MockOccurredMessage receiver: #receiver selector: #selector.
	message result: #otherResult asOccurredMessageResult.
	
	result := spec validate: { message }.
	
	result should be isFailure.
	result where description should equal: '#object was not returned by anybody but it should be #receiver selector'
]

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testFailedValidationWhenSenderWasWrong [
	
	| spec message result |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).

	message := MockOccurredMessage receiver: #receiver2 selector: #selector.
	message result: #object asOccurredMessageResult.
	
	result := spec validate: { message }.
	
	result should be isFailure.
	result where description should equal: '#object was returned from #receiver2 selector but it should be #receiver selector'
]

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testMatches [
	
	| spec message |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).

	message := MockOccurredMessage receiver: #receiver selector: #selector.
	
	message result: #object asOccurredMessageResult.
	spec should be matches: {message}.
	
	message result: #anotherResult asOccurredMessageResult.
	spec should not be matches: {message}.
]

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testMatchesMultipleSenders [
	
	| spec expectedSenderMessage anotherSenderMessage |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).

	expectedSenderMessage := MockOccurredMessage receiver: #receiver selector: #selector.
	expectedSenderMessage result: #object asOccurredMessageResult.
	anotherSenderMessage := MockOccurredMessage receiver: #receiver selector: #anotherSelector.	
	anotherSenderMessage result: #object asOccurredMessageResult.
	
	spec should be matches: {anotherSenderMessage. expectedSenderMessage}
]

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testMatchesWhenDenialApplied [
	
	| spec message |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).
	spec denial: true.

	message := MockOccurredMessage receiver: #receiver selector: #selector.	
	message result: #object asOccurredMessageResult.
	
	spec should not be matches: {message}.
	
	message result: #anotherResult asOccurredMessageResult.
	spec should be matches: {message}.
]

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testSucceedValidation [
	
	| spec message result |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).

	message := MockOccurredMessage receiver: #receiver selector: #selector.
	message result: #object asOccurredMessageResult.
	
	result := spec validate: { message }.
	
	result should beKindOf: SpecOfMessagesValidationSuccess.
	result requiredOccurredMessages should equal: {message}.
]

{ #category : #tests }
SpecOfExpectedObjectSenderTests >> testSucceedValidationOfMultipleSenders [
	
	| spec result expectedSenderMessage anotherSenderMessage |
	spec := SpecOfExpectedObjectSender for: #object returnedFrom: (
		SpecOfExpectedMessage from: (MockOccurredMessage receiver: #receiver selector: #selector)).
	
	expectedSenderMessage := MockOccurredMessage receiver: #receiver selector: #selector.
	expectedSenderMessage result: #object asOccurredMessageResult.
	anotherSenderMessage := MockOccurredMessage receiver: #receiver selector: #anotherSelector.	
	anotherSenderMessage result: #object asOccurredMessageResult.
	
	result := spec validate: { anotherSenderMessage. expectedSenderMessage }.
	
	result should beKindOf: SpecOfMessagesValidationSuccess.
	result requiredOccurredMessages should equal: { expectedSenderMessage }..
]
