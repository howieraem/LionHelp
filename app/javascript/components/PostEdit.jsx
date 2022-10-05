import React, {Component} from 'react';
import {Button, Form, FormGroup, Label, Input, Col, Row, FormFeedback} from 'reactstrap';
import DateTimePicker from 'react-datetime-picker';
import { locOptions } from './locations.js';
import Select from "react-select";

class PostEdit extends Component {
    constructor(props) {
        super(props);

        this.state = {
            id: null,
            title: '',
            loc: '',
            locspec: '',
            credit: 0.0,
            startTime: new Date(),
            endTime: new Date(),
            content: '',
            touched: {
                title: false,
                loc: false,
                credit: false
            }
        }

        this.handleInputChange = this.handleInputChange.bind(this);
        this.handleSelectChange = this.handleSelectChange.bind(this);
        this.handleStartTimeChange = this.handleStartTimeChange.bind(this);
        this.handleEndTimeChange = this.handleEndTimeChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleBlur = this.handleBlur.bind(this);
    }

    componentDidMount() {
        if (!this.props.login) {
            this.props.history.push('/');   // the home page will alert anyways, no need to alert here
            return;
        }
        const path = this.props.history.location.pathname.split("/");
        const id = path[path.length - 1];
        this.setState({ id });

        const url = "/api/v1/posts/show/" + id;
        fetch(url)
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error("Network response was not ok.");
            })
            .then(response => this.setState({
                title: response.title,
                loc: { label: response.location, value: response.location.split(' - ')[0] },
                locspec: response.room,
                credit: response.credit,
                startTime: new Date(response.startTime),
                endTime: new Date(response.endTime),
                content: response.taskDetails,
            }))
            .catch(() => this.props.history.push("/"));
    }

    handleInputChange(event) {
        const target = event.target;
        const value = target.value;
        const name = target.name;

        this.setState({
            [name]: value
        });
    }

    handleSelectChange = (loc) => {
        this.setState({ loc });
    };

    handleStartTimeChange = date => {
        this.setState({
            startTime: date
        });
    };

    handleEndTimeChange = date => {
        this.setState({
            endTime: date
        });
    };

    handleSubmit(event) {
        event.preventDefault();
        const sDate = (this.state.startTime.getMonth() + 1) + "/" + this.state.startTime.getDate() + "/" + this.state.startTime.getFullYear() + " " + this.state.startTime.getHours() + ":" + this.state.startTime.getMinutes();
        const eDate = (this.state.endTime.getMonth() + 1) + "/" + this.state.endTime.getDate() + "/" + this.state.endTime.getFullYear() + " " + this.state.endTime.getHours() + ":" + this.state.endTime.getMinutes();
        const url = `/api/v1/posts/update/${this.state.id}`;
        const databody = {
            "title": this.state.title,
            "location": this.state.loc["label"],
            "room": this.state.locspec,
            "startTime": sDate,
            "endTime": eDate,
            "taskDetails": this.state.content,
            "credit": this.state.credit,
        };
        fetch(url, {
            method: "PUT",
            headers: {
                "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
                "Content-Type": "application/json"
            },
            body: JSON.stringify(databody)
        })
            .then(response => {
                if (response.ok) {
                    return;
                }
                throw new Error("Network response was not ok.");
            })
            .then(response => {
                this.props.history.push('/cur_posts');
            })
            .catch(error => console.log(error.message));
    }

    handleBlur = (field) => (evt) => {
        this.setState({
            touched: {...this.state.touched, [field]: true},
        });
    }

    validate(title, loc, credit) {
        const errors = {
            title: '',
            loc: '',
            locspec: '',
            credit: ''
        };

        if (this.state.touched.title && title.length < 1)
            errors.title = 'Title should be >= 1 characters';

        if (this.state.touched.loc && loc.length < 1)
            errors.loc = 'Location cannot be empty';

        if (this.state.touched.locspec && locspec.length < 1)
            errors.locspec = 'Please specify your location';

        if (this.state.touched.credit && isNaN(credit))
            errors.credit = 'Credit must be a float number, such as 5.0';
        else if (this.state.touched.credit && parseFloat(credit) < 0.0)
            errors.credit = 'Credit must be at least 0.0';

        return errors;
    }

    render() {
        const errors = this.validate(this.state.title, this.state.loc, this.state.credit);
        return (
            <div className="container">
                <div className="row">
                    <div className="col-12">
                        <h5 style={{marginTop: "100px", fontFamily: "Arial Black"}}>Edit Your Request</h5>
                        <hr className="separation"/>
                    </div>
                </div>
                <div className="row row-content">
                    <Form onSubmit={this.handleSubmit} className="form-style">
                        <Row>
                            <Col sm={12} md={{size: 6, offset: 3}}>
                                <FormGroup className="form-style-form-group">
                                    <Label htmlFor="title" className="form-style-label">Title (Required)</Label>
                                    <Input type="text" id="title" name="title" className="form-style-input"
                                           placeholder="Title" value={this.state.title} valid={errors.title === ''}
                                           invalid={errors.title !== ''} onChange={this.handleInputChange}
                                           onBlur={this.handleBlur('title')}/>
                                    <FormFeedback>{errors.title}</FormFeedback>
                                </FormGroup>
                            </Col>
                        </Row>
                        <Row>
                            {/*<Col xs={12} md={{size: 6, offset: 3}}>*/}
                            {/*    <FormGroup className="form-style-form-group">*/}
                            {/*        <Label htmlFor="loc" className="form-style-label">Location (Required)</Label>*/}
                            {/*        <Input type="text" id="loc" name="loc" className="form-style-input"*/}
                            {/*               placeholder="Location" value={this.state.loc} valid={errors.loc === ''}*/}
                            {/*               invalid={errors.loc !== ''} onChange={this.handleInputChange}*/}
                            {/*               onBlur={this.handleBlur('loc')}/>*/}
                            {/*        <FormFeedback>{errors.loc}</FormFeedback>*/}
                            {/*    </FormGroup>*/}
                            {/*</Col>*/}
                            <Col xs={12} md={{size:6, offset:3}}>
                                <FormGroup className="form-style-form-group">
                                    <Label htmlFor="loc" className="form-style-label">Location (Required)</Label>
                                    <Select
                                        id="loc"
                                        name="loc"
                                        value={this.state.loc}
                                        onChange={this.handleSelectChange}
                                        options={locOptions}
                                        isSearchable={true}
                                        isClearable={true}
                                    />
                                    <FormFeedback>{errors.loc}</FormFeedback>
                                </FormGroup>
                            </Col>
                            <Col xs={12} md={{size:6, offset:3}}>
                                <FormGroup className="form-style-form-group">
                                    <Label htmlFor="locspec" className="form-style-label">Location Details (Required)</Label>
                                    <Input  type="text" id="locspec" name="locspec" className="form-style-input"
                                            placeholder="Please specify your location" value={this.state.locspec}
                                            valid={errors.locspec === ''} invalid={errors.locspec !== ''}
                                            onChange={this.handleInputChange} onBlur={this.handleBlur('locspec')}
                                    />
                                    <FormFeedback>{errors.locspec}</FormFeedback>
                                </FormGroup>
                            </Col>
                        </Row>
                        <Row>
                            <Col xs={12} md={{size: 6, offset: 3}}>
                                <FormGroup className="form-style-form-group">
                                    <Label htmlFor="startTime" className="form-style-label">Start Time
                                        (Required)</Label>
                                    <DateTimePicker id="startTime" name="startTime" className="form-style-input"
                                                    format="MM/dd/y H:mm" selected={this.state.startTime}
                                                    value={this.state.startTime} onChange={this.handleStartTimeChange}/>
                                </FormGroup>
                            </Col>
                        </Row>
                        <Row>
                            <Col xs={12} md={{size: 6, offset: 3}}>
                                <FormGroup className="form-style-form-group">
                                    <Label htmlFor="endTime" className="form-style-label">End Time (Required)</Label>
                                    <DateTimePicker id="endTime" name="endTime" format="MM/dd/y H:mm"
                                                    selected={this.state.endTime} value={this.state.endTime}
                                                    onChange={this.handleEndTimeChange}/>
                                </FormGroup>
                            </Col>
                        </Row>
                        <Row>
                            <Col xs={12} md={{size: 6, offset: 3}}>
                                <FormGroup className="form-style-form-group">
                                    <Label htmlFor="credit" className="form-style-label">Credit (Required)</Label>
                                    <Input type="text" id="credit" name="credit" className="form-style-input"
                                           placeholder="Credit" value={this.state.credit} valid={errors.credit === ''}
                                           invalid={errors.credit !== ''} onChange={this.handleInputChange}
                                           onBlur={this.handleBlur('credit')}/>
                                    <FormFeedback>{errors.credit}</FormFeedback>
                                </FormGroup>
                            </Col>
                        </Row>
                        <Row>
                            <Col sm={12} md={{size: 6, offset: 3}}>
                                <FormGroup className="form-style-form-group">
                                    <Label htmlFor="content" className="form-style-label">Request in detail</Label>
                                    <Input type="textarea" id="content" name="content" rows="5"
                                           value={this.state.content} onChange={this.handleInputChange}/>
                                </FormGroup>
                            </Col>
                        </Row>
                        <Row>
                            <Col sm={12} md={{size: 6, offset: 3}}>
                                <FormGroup>
                                    <Button
                                        type="submit"
                                        value="submit"
                                        style={{
                                            backgroundColor: "rgba(0, 51, 160, 1)",
                                            width: "100%",
                                            fontFamily: "Arial Black"
                                        }}
                                        disabled={errors.loc || errors.locspec || errors.credit || errors.title}
                                    >
                                        Update
                                    </Button>
                                </FormGroup>
                            </Col>
                        </Row>
                    </Form>
                </div>
            </div>
        );
    }
}

export default PostEdit;