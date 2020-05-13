import React from 'react'

class PayTm extends React.Component {
  render() {
    return (
      <div>
        <div className="field">
          <label htmlFor="order_paytm_no">PayTm No</label>
          <input type="text"
                 name="order[paytm_no]" 
                 id="order_paytm_no"
                 placeholder="e.g. 9912345678" />
        </div>
      </div>
    );
  }
}
export default PayTm
