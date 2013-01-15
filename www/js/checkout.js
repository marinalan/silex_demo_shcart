function setPaymentInfo(isChecked)
{
	with (window.document.frmCheckout) {
		if (isChecked) {
			checkout1_billing_fullname.value       = checkout1_shipping_fullname.value;
			checkout1_billing_street.value         = checkout1_shipping_street.value;
			checkout1_billing_city.value           = checkout1_shipping_city.value;
			checkout1_billing_zip.value            = checkout1_shipping_zip.value;
			checkout1_billing_province_state.value = checkout1_shipping_province_state.value;
			checkout1_billing_country.value        = checkout1_shipping_country.value;
			checkout1_billing_phone.value          = checkout1_shipping_phone.value;
			
			checkout1_billing_fullname.readOnly       = true;
			checkout1_billing_street.readOnly         = true;
			checkout1_billing_city.readOnly           = true;
			checkout1_billing_zip.readOnly            = true;
			checkout1_billing_province_state.readOnly = true;
			checkout1_billing_country.readOnly        = true;			
			checkout1_billing_phone.readOnly          = true;
		} else {
			checkout1_billing_fullname.readOnly       = false;
			checkout1_billing_street.readOnly         = false;
			checkout1_billing_city.readOnly           = false;
			checkout1_billing_zip.readOnly            = false;
			checkout1_billing_province_state.readOnly = false;
			checkout1_billing_country.readOnly        = false;			
			checkout1_billing_phone.readOnly          = false;
		}
	}
}


function checkShippingAndPaymentInfo()
{
	with (window.document.frmCheckout) {
		if (isEmpty(checkout1_shipping_fullname, 'Enter full name')) {
			return false;
		} else if (isEmpty(checkout1_shipping_street, 'Enter shipping street address')) {
			return false;
		} else if (isEmpty(checkout1_shipping_phone, 'Enter phone number')) {
			return false;
		} else if (isEmpty(checkout1_shipping_province_state, 'Enter shipping address state')) {
			return false;
		} else if (isEmpty(checkout1_shipping_city, 'Enter shipping address city')) {
			return false;
		} else if (isEmpty(checkout1_shipping_zip, 'Enter the shipping address postal/zip code')) {
			return false;
		} else if (isEmpty(checkout1_shipping_country, 'Enter the shipping address country')) {
			return false;
		} else if (isEmpty(checkout1_billing_fullname, 'Enter full name for billing')) {
			return false;
		} else if (isEmpty(checkout1_billing_street, 'Enter Billing address')) {
			return false;
		} else if (isEmpty(checkout1_billing_phone, 'Enter phone number')) {
			return false;
		} else if (isEmpty(checkout1_billing_province_state, 'Enter Billing address state')) {
			return false;
		} else if (isEmpty(checkout1_billing_city, 'Enter Billing address city')) {
			return false;
		} else if (isEmpty(checkout1_billing_zip, 'Enter the Billing address postal/zip code')) {
			return false;
		} else if (isEmpty(checkout1_billing_country, 'Enter the Billing address country')) {
			return false;
		} else {
			return true;
		}
	}
}
