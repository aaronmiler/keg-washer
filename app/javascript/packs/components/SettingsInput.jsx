import React, { PureComponent } from 'react'
import _ from "lodash"
import KeyboardedInput from 'react-touch-screen-keyboard';
import 'react-touch-screen-keyboard/lib/Keyboard.scss'; // if you've got sass-loader

export default class SettingsInput extends PureComponent {
  constructor(props) {
    super(props)

    this.state = {
      value: props.value
    }
  }

  updateValue = (val) => this.setState({value: val})
  submit = () => this.props.updateSetting(this.props.name, this.state.value)

  render () {
    const KeyboardMapping = [
      [ '7', '8', '9' ],
      [ '4', '5', '6' ],
      [ '1', '2', '3' ],
      [ '', '0', '*bs' ],
    ]

    return(
      <div className="SettingsInput">
        <h3>{ _.startCase(this.props.title) }</h3>
        <KeyboardedInput
          enabled
          required
          keyboardClassName="Keyboard"
          type="number"
          onChange={this.updateValue}
          onBlur={this.submit}
          value={this.state.value}
          name={this.props.name}
          defaultKeyboard={KeyboardMapping}
          showSpacebar={false}
          showShift={false}
          showSymbols={false}
          showNumericRow={false}
        />
      </div>
    )
  }
}
