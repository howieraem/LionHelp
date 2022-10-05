import React from "react";
import { Collapse, Button} from 'reactstrap';

class SinglePost extends React.Component{
    constructor(props){
        super(props);
        this.state = {
            title: '',
            loc: '',
            credit: 0.0,
            startTime: '',
            endTime: '',
            content: '',
            email:''
        }
    }

    componentDidMount(){
        if(localStorage.getItem('token')!=null){
            const path = this.props.history.location.pathname.split("/");
            const id = path[path.length-1];
            const url = "/api/v1/posts/help/"+id;
            fetch(url)
                .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error("Network response was not ok.");
                })
                .then(response => this.setState({ 
                                        title: response.title,
                                        loc: response.location,
                                        credit: response.credit,
                                        startTime: response.startTime,
                                        endTime: response.endTime,
                                        content: response.taskDetails,
                                        email: response.email 
                                                }))
                .catch(() => this.props.history.push("/"));
        }
        else{
            alert("Please login or sign up first!");
        }
    }


    render(){

        return(
            <div className="container">
                <div className="col-12" style={{marginTop:"100px"}}>
                    <div className="row">
                        <div className="col-12 col-md-6">
                        <h5 style={{fontFamily:"Arial Black", display:"inline"}}>Request Details</h5>
                        </div>
                    </div>
                    <hr className="separation" />
                </div>
                <div className="col-12" style={{marginTop:"22px"}}>
                    <div className="row">
                        <div className="col-12 col-md-6 offset-md-3" style={{marginTop:"20px"}}>
                            <p><strong>Email:</strong> {this.state.email}</p>
                        </div>
                        <div className="col-12 col-md-6 offset-md-3">
                            <p><strong>Title:</strong> {this.state.title}</p>
                        </div>
                        <div className="col-12 col-md-6 offset-md-3">
                            <p><strong>Location:</strong> {this.state.loc}</p>
                        </div>
                        <div className="col-12 col-md-6 offset-md-3">
                            <p><strong>Start Time:</strong> {this.state.startTime}</p>
                        </div>
                        <div className="col-12 col-md-6 offset-md-3">
                            <p><strong>End Time:</strong> {this.state.endTime}</p>
                        </div>
                        <div className="col-12 col-md-6 offset-md-3">
                            <p><strong>Credit:</strong> {this.state.credit}</p>
                        </div>
                        <div className="col-12 col-md-6 offset-md-3">
                            <p><strong>Request:</strong> {this.state.content}</p>
                        </div>
                        <hr className="separation" />
                    </div>
                </div>
            </div>
        );
    }
}

export default SinglePost;