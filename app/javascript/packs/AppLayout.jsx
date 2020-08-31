import React, { Component } from 'react'
import Cortex from 'cortexjs'
import axios from 'axios'

import consumer from "channels/consumer"
import { ActionCableProvider } from 'react-actioncable-provider';

import ButtonWidget from 'packs/components/ButtonWidget'
import SettingsInput from 'packs/components/SettingsInput'

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

  updateSetting = (key, value) => {
    const req = axios.post("/api/settings", { key: key, value: value })
    req.then((data) => {
      this.state.data.merge(data)
    })
  }

  render () {
    return(
      <div>
        <ActionCableProvider cable={consumer}>
          { Object.entries(this.state.data.settings.val()).map(([k, v]) => {
            return(
              <SettingsInput
                key={k}
                title={`${k} Time`}
                value={ v || 20 }
                name={k}
                updateSetting={this.updateSetting}
              />
            )
          })}
        </ActionCableProvider>
      </div>
    )
  }
}
