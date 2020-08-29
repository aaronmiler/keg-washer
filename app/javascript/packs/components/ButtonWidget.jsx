import React, { Component } from 'react'

import { ActionCableConsumer } from 'react-actioncable-provider';

export default class ButtonWidget extends Component {
  constructor(props) {
    super(props);

    this.handleReceived = this.handleReceived.bind(this);
  }

  handleReceived = ({ state }) => {
    this.props.data.set({state: state})
  }

  buttonState = () => {
    const s = this.props.data.getValue().state
    console.log(s)
    return s == true || s == 'true'
  }

  render() {
    return(
      <div>
        <ActionCableConsumer
          channel={{channel: 'ButtonChannel', button: this.props.button}}
          onReceived={this.handleReceived}
        >
          <p>{ JSON.stringify(this.props.data.getValue().state) }</p>
          The {this.props.button} button is { this.buttonState() ? "On" : "Off" }
        </ActionCableConsumer>
      </div>
    )
  }
}
