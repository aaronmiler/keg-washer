import React, { Component } from 'react'
import Cortex from 'cortexjs'

import consumer from "channels/consumer"
import { ActionCableProvider } from 'react-actioncable-provider';

import ButtonWidget from 'packs/components/ButtonWidget'

export default class AppLayout extends Component {
  constructor(props) {
    super(props);

    // Assume you pass your data into props as myData
    var myCortex = new Cortex(props.data, (updatedCortex) => {
      this.setState({data: updatedCortex});
    });

    this.state = { data: myCortex };
  }

  handleReceived(message) {
    this.state.data.merge(message)
  }

  render () {
    return(
      <div>
        <ActionCableProvider cable={consumer}>
          <div>'hi'</div>
          <ButtonWidget key="red" data={this.state.data.red } button="red" />
          <ButtonWidget key="green" data={this.state.data.green } button="green" />
        </ActionCableProvider>
      </div>
    )
  }
}
