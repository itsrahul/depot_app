import React from 'react'

class Upi extends React.Component {
  render() {
    return (
      <div>
        <div className="field">
          <label htmlFor="order_upi_id">UPI Id</label>
          <input type="text"
                 name="order[upi_id]" 
                 id="order_upi_id"
                 placeholder="e.g. upi@bank" />
        </div>
      </div>
    );
  }
}
export default Upi
