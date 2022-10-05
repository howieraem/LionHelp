import React from "react";
import { Route, Switch, withRouter } from "react-router-dom";
import Home from "../components/Home";
import Header from "../components/Header";
import Post from "../components/Post";
import Profile from "../components/Profile";
import MyPosts from "../components/MyPosts";
import HelpHistory from "../components/HelpHistory";
import SinglePost from "../components/SinglePost";
import NotFound from "../components/NotFound";
import Loading from "../components/Loading";
import PostEdit from "../components/PostEdit";

const UsernameContext = React.createContext('');

class Index extends React.Component{

    constructor(props){
        super(props);
        this.state = { usrId: -1, email: '', login: false, loading: true };
    }

    onUsernameChange = (usrId, email, login) => {
        this.setState({
            usrId: usrId,
            email: email,
            login: login,
        });
    }

    componentDidMount() {
        const token = localStorage.getItem('token');
        if (!token) {
            this.setState({ loading: false })
            return;
        }
        const url = '/api/v1/auth';
        fetch(url, {
            method: "GET",
            headers: {
                "Authorization": token,
                "Content-Type": "application/json"
            },
        }).then(response => {
            if (response.ok) {
                return response.json();
            }

            // invalid token, log out
            this.setState({
                usrId: -1,
                email: '',
                login: false
            })
            localStorage.removeItem('token');
            this.setState({ loading: false })
            return new Error("Failed to get the current logged in user!");
        }).then(json => {
            this.setState({
                usrId: json.user.id,
                email: json.user.email,
                login: true,
                loading: false
            })
        }).catch(err => { console.log(err); });
    }

    render() {
        if (this.state.loading) {
            return (
                <Loading />
            );
        }
        return (

                <UsernameContext.Provider value={{state: this.state}}>
                    <Header history={this.props.history} onUsernameChange={this.onUsernameChange} login={this.state.login}/>
                    <Switch>
                        <Route path="/" exact component={()=><Home history={this.props.history} email={this.state.email} login={this.state.login} />} />
                        <Route path="/post" exact component={()=><Post history={this.props.history} email={this.state.email} login={this.state.login} />} />
                        <Route path="/cur_posts" exact component={()=><MyPosts login={this.state.login} history={this.props.history} email={this.state.email} cur={true} />} />
                        <Route path="/pre_posts" exact component={()=><MyPosts login={this.state.login} history={this.props.history} email={this.state.email} cur={false} />} />
                        <Route path="/help_history" exact component={()=><HelpHistory login={this.state.login} history={this.props.history} email={this.state.email} />} />
                        <Route path="/profile" exact component={()=><Profile usrId={this.state.usrId} email={this.state.email} login={this.state.login} />} />
                        <Route path="/spost/:id" exact component={()=><SinglePost history={this.props.history} login={this.state.login} />} />
                        <Route path="/edit/:id" exact component={()=><PostEdit history={this.props.history} login={this.state.login} />} />
                        <Route component={NotFound} />
                    </Switch>
                </UsernameContext.Provider>

        );
    }

}

export default withRouter(Index);
