//
//	OrganisationDetails.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class OrganisationDetails{

	var consents : [Consent]!
	var organization : Organization!
    var purposeConsents : [PurposeConsent]!
    var consentID : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!) {
		if json.isEmpty{
			return
		}
		consents = [Consent]()
        consentID = json["ConsentID"].string
		let consentsArray = json["Consents"].arrayValue
		for consentsJson in consentsArray{
			let value = Consent(fromJson: consentsJson)
			consents.append(value)
		}
		let organizationJson = json["Organization"]
		if !organizationJson.isEmpty{
			organization = Organization(fromJson: organizationJson)
		}
        purposeConsents = [PurposeConsent]()
        let purposeConsentsArray = json["PurposeConsents"].arrayValue
        for purposeConsentsJson in purposeConsentsArray{
            let value = PurposeConsent(fromJson: purposeConsentsJson)
            purposeConsents.append(value)
        }
	}
}
